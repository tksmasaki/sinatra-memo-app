# frozen_string_literal: true

require 'json'

class Memo
  FILE_PATH = File.expand_path('../db/memos.json', __dir__)

  def find_all
    retrieve_data.reject { |k, _v| k == 'next_id' }
  end

  def find_by(id)
    retrieve_data.find { |k, _v| k == id }
  end

  def create(params)
    memo_data = retrieve_data
    new_id = memo_data['next_id']

    memo_data[new_id] = {
      title: params['title'],
      content: params['content']
    }
    memo_data['next_id'] = (new_id.to_i + 1).to_s

    save_hash_to_json(memo_data)
    new_id
  end

  def update(id, params)
    memo_data = retrieve_data

    memo_data[id] = {
      title: params['title'],
      content: params['content']
    }

    save_hash_to_json(memo_data)
  end

  def delete(id)
    memo_data = retrieve_data
    memo_data.delete(id)
    save_hash_to_json(memo_data)
  end

  private

  def retrieve_data
    File.open(FILE_PATH) { |f| JSON.parse(f.read) }
  end

  def save_hash_to_json(hash)
    File.open(FILE_PATH, 'w') { |file| JSON.dump(hash, file) }
  end
end
