# frozen_string_literal: true

require 'pg'

class Memo
  @conn = PG.connect(dbname: 'sinatra_memo_app')
  @conn.internal_encoding = 'UTF-8'

  class << self
    def find_all
      memos = []
      sql = 'SELECT * FROM memos'
      @conn.exec(sql) { |rows| rows.each { |row| memos << row } }
      memos
    end

    def find_by(id)
      sql = 'SELECT * FROM memos WHERE id = $1'
      @conn.exec_params(sql, [id])[0]
    end

    def create(params)
      sql = <<~'SQL'
        INSERT
          INTO memos (title, content)
          VALUES ($1, $2)
          RETURNING id
      SQL
      @conn.exec_params(sql, [params['title'], params['content']])[0]['id']
    end

    def update(id, params)
      sql = <<~'SQL'
        UPDATE memos
          SET title = $1, content = $2
          WHERE id = $3
      SQL
      @conn.exec_params(sql, [params['title'], params['content'], id])
    end

    def delete(id)
      sql = 'DELETE FROM memos WHERE id = $1'
      @conn.exec_params(sql, [id])
    end
  end
end
