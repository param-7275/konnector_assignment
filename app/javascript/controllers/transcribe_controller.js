import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "live", "final", "summary"]

  connect() {
    this.recognition = null
    this.finalTranscript = ""
  }

  start() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SpeechRecognition) {
      alert("Browser does not support Web Speech API. Please use Chrome.")
      return
    }

    this.finalTranscript = ""
    this.liveTarget.innerText = ""
    this.finalTarget.innerText = "—"
    this.summaryTarget.innerText = "—"

    this.recognition = new SpeechRecognition()
    this.recognition.continuous = true
    this.recognition.interimResults = true
    this.recognition.lang = "en-IN" 

    this.recognition.onresult = (event) => {
      let interim = ""
      for (let i = event.resultIndex; i < event.results.length; i++) {
        const res = event.results[i]
        if (res.isFinal) {
          this.finalTranscript += res[0].transcript + " "
        } else {
          interim += res[0].transcript + " "
        }
      }
      this.liveTarget.innerText = (this.finalTranscript + interim).trim()
    }

    this.recognition.onerror = (e) => {
      console.error(e)
      this.statusTarget.innerText = `Error: ${e.error || 'unknown'}`
    }

    this.recognition.onstart = () => { this.statusTarget.innerText = "Listening..." }
    this.recognition.onend = () => { this.statusTarget.innerText = "Stopped" }

    this.recognition.start()
  }

  stop() {
    if (!this.recognition) return
    this.recognition.stop()
    this.finalTarget.innerText = this.finalTranscript.trim() || "—"

    const token = document.querySelector('meta[name="csrf-token"]').content
    fetch("/transcriptions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ content: this.finalTranscript.trim() })
    })
    .then(res => {
      if (!res.ok) throw new Error("Network response was not ok")
      return res.json()
    })
    .then(json => {
      if (json.id) this.pollSummary(json.id)
      else this.summaryTarget.innerText = "Failed to create transcription"
    })
    .catch(err => {
      console.error(err)
      this.summaryTarget.innerText = "Error sending transcript"
    })
  }

  pollSummary = async (id, attempts = 0) => {
    try {
      const response = await fetch(`/transcriptions/${id}`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const json = await response.json();
      const { summary, status } = json?.data?.attributes ?? {};

      if (summary?.length) {
        this.summaryTarget.innerText = summary;
      } else if ((status === "processing") && attempts < 20) {
        setTimeout(() => this.pollSummary(id, attempts + 1), 1500);
      } else {
        this.summaryTarget.innerText = "Summary not ready. Try again later.";
      }
    } catch (err) {
      console.error("Error fetching summary:", err);
      this.summaryTarget.innerText = "Error fetching summary";
    }
  };
}
