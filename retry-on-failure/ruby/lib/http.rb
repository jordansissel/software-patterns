require "ftw" # gem install 'ftw' 

module HTTP
  class Error < StandardError; end
  def self.get(url)
    response = agent.get!(url)

    # Raise an exception on server errors.
    if (500..599).include?(response.status)
      raise Error, "Status code #{response.status} from GET #{url}"
    end

    return response
  end # def self.get

  def self.agent
    @agent ||= FTW::Agent.new
  end # def self.agent
end # module HTTP
