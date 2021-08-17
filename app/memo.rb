# frozen_string_literal: true

require 'json'

class Memo
  FILE_PATH = File.expand_path('../db/memos.json', __dir__)

  def find_all
    retrieve_data[:memos]
  end

  def find_by(id)
    retrieve_data[:memos].find { |i| i[:id] == id }
  end

  def create(params)
    memo_data = retrieve_data
    id = memo_data[:next_id]

    memo_data[:memos] << {
      id: id,
      title: params['title'],
      content: params['content']
    }
    memo_data[:next_id] += 1

    save_hash_to_json(memo_data)
    memo_data[:memos].find { |i| i[:id] == id }
  end

  def update(id, params)
    memo_data = retrieve_data

    memo_data[:memos].map! do |memo|
      if memo[:id] == id
        {
          id: id,
          title: params['title'],
          content: params['content']
        }
      else memo
      end
    end

    save_hash_to_json(memo_data)
    memo_data[:memos].find { |i| i[:id] == id }
  end

  def delete(id)
    memo_data = retrieve_data
    memo_data[:memos].delete_if { |i| i[:id] == id }
    save_hash_to_json(memo_data)
  end

  private

  def retrieve_data
    File.open(FILE_PATH) { |f| JSON.parse(f.read, symbolize_names: true) }
  end

  def save_hash_to_json(hash)
    File.open(FILE_PATH, 'w') { |file| JSON.dump(hash, file) }
  end
end
