class CreateTranscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :transcriptions do |t|
      t.text :content
      t.text :summary
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
