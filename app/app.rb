# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative './memo'

class MemoApp < Sinatra::Base
  configure do
    enable :method_override
  end

  configure :development do
    register Sinatra::Reloader
    also_reload File.expand_path('./memo.rb', __dir__)
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html text
    end
  end

  before do
    @memo = Memo.new
    pass unless request.post? || request.patch?

    redirect to('/memos') if params['title'].blank?
  end

  before '/*/' do
    redirect request.path_info.delete_suffix('/')
  end

  get '/' do
    redirect to('/memos')
  end

  get '/memos' do
    erb :index, locals: {
      title: 'Home',
      memos: @memo.find_all
    }
  end

  get '/memos/new' do
    erb :new, locals: { title: 'Create new' }
  end

  get '/memos/:id' do |id|
    memo = @memo.find_by(id)
    raise Sinatra::NotFound unless memo

    erb :show, locals: {
      title: memo[1]['title'],
      memo: memo
    }
  end

  get '/memos/:id/edit' do |id|
    memo = @memo.find_by(id)
    raise Sinatra::NotFound unless memo

    erb :edit, locals: {
      title: "Edit | #{memo[1]['title']}",
      memo: memo
    }
  end

  post '/memos' do
    new_id = @memo.create(params)
    redirect to("/memos/#{new_id}")
  end

  patch '/memos/:id' do |id|
    @memo.update(id, params)
    redirect to("/memos/#{id}")
  end

  delete '/memos/:id' do |id|
    @memo.delete(id)
    redirect to('/memos')
  end

  not_found do
    erb :not_found, locals: { title: 'Page not found' }
  end
end
