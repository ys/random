require "active_support/all"
require "gastly"
require "rest-client"
require "nokogiri"
require "yaml"
require "pp"
require "securerandom"

class Link
  attr_reader :data, :file, :content
  YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

  def initialize(file)
    @file = file
    file_content = File.read(file)
    file_content =~ YAML_FRONT_MATTER_REGEXP
    @data, @content = YAML.load($1), Regexp.last_match.post_match
    ensure_uuid
  end

  def ensure_uuid
    data["uuid"] ||= SecureRandom.uuid
  end

  def uuid
    data["uuid"]
  end

  def save
    write
  end

  def capture
    path = "content/links/images/#{uuid}.png"
    Gastly.capture(data["link"], path)
  end

  def download_image
    unless data["headImage"]
      update_head_image
    end
    unless data["headImage"]
      capture
      return
    end
    ext = data["headImage"].match?(/png/) ? "png" : "jpg"
    path = "content/links/images/#{uuid}.#{ext}"
    return if File.exists?(path)
    `wget -O #{path} "#{data['headImage']}"`
  end

  def update_head_image
    return unless head_image
    data["headImage"] = head_image
    puts "#{file} -> #{head_image}"
    write
  end

  def head_image
    return unless web_content
    puts web_content
    if web_content.at("meta[property='og:image']")
      return web_content.at("meta[property='og:image']")["content"]
    end
    if web_content.at("meta[property='twitter:image']")
      return web_content.at("meta[property='twitter:image']")["content"]
    end
  end

  def web_content
    @web_content ||= Nokogiri::HTML(RestClient.get(data["link"]))
  rescue StandardError => e
    puts "#{file} -> #{e}"
    nil
  end

  def write
    File.write(file, YAML.dump(data)+ "---\n\n" + content)
  end
end

pp Dir.glob("content/links/*.md").map { |f| l = Link.new(f); l.download_image}
