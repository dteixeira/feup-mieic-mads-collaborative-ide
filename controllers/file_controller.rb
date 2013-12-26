class FileController < ApplicationController

  helpers FileHelpers

  # Sets the project root. Possible not needed.
  # TODO Protect.
  post '/set_root' do
    return 'Internal error' if params[:root].nil? || params[:root].empty? || !File.directory?(params[:root])
    settings.browser_root = params[:root][-1, 1] == '/' ? params[:root].slice(0...-1) : params[:root]
  end

  # List a directory to the first depth level.
  post '/list_directory' do
    @files = list_directory settings.browser_root, params[:dir]
    slim 'file/list'.to_sym
  end

  # Returns the unique hash of a file.
  post '/file_hash' do
    file = params[:file]
    return { success: false }.to_json if file.nil? || file.empty? || !valid_file(settings.browser_root, file)
    return { success: true, hash: generate_hash(settings.project_id, file), project: settings.project_id }.to_json
  end

  # Returns a files contents.
  post '/load_file' do
    file = params[:file]
    return { success: false }.to_json if file.nil? || file.empty? || !valid_file(settings.browser_root, file)
    content = load_file settings.browser_root, file
    return { success: false }.to_json unless file
    return { success: true, content: content}.to_json
  end

end