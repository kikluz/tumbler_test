module TumblrHelper

  @@URL = 'kikluz.tumblr.com/'
  @@oauth= {
    :consumer_key => 'tHlvMzGjPMxKXZGcFcqWR5JALAYKVmkQKycevNcDYgzdUY0JUL',
    :consumer_secret => 'pSKZDbdBqjRcH15cF7iO2fGb8X0tzbVSJG3KY2FIfzDqZeV0ho',
    :oauth_token => 'hTEi0lHKy8LgWDW6TjOJyRi4iEo9By40biNTPrRbMF9TTninSa',
    :oauth_token_secret => 'E3FO6oufptOSpUU6CcpamtIS3r137JmGfMmIdoiudJ84X8fomD'
  }

  # create the client
  def get_client()
    return Tumblr::Client.new(@@oauth)
  end

  # saves entire blog into yml in /log
  def blog_to_yml()
    blog_hash = get_client.posts(@@URL)
    File.open("log/hash_#{Time.now.to_i}.yml", "w") do |file|
      file.write blog_hash.to_yaml
    end
  end

  # gets all blog posts
  def get_posts()
    return get_client.posts(@@URL)['posts']
  end

  # filters posts by tag
  def by_tag(tag_name)
    # events
    return get_posts.select { |p|
      p['tags'].include? tag_name unless p['tags'].nil?
    }
  end

  # format the output into structured hash
  def by_tag_formatted(tag_name)
    posts = by_tag(tag_name)
    result = []
    posts.each do |post|
      if post['type']=='photo'

        # get data
        type = post['type']
        image_url = post['photos'].first['original_size']['url']
        caption = post['caption']
        slug = post['slug']
        url = "/#{tag_name}/#{slug}"

        # structure it
        result << {
          type: type,
          title: truncate_words(strip_tags(caption), length: 10),
          body: caption,
          image_url: image_url,
          slug: slug,
          url: url,
          relative_url: url + '/index.html'
        }

      else

        # get data
        title = strip_tags(post['title'])
        body = post['body']
        slug = post['slug']
        url = "/#{tag_name}/#{slug}"

        # structure it
        result << {
          type: type,
          title: title,
          body: body,
          image_url: nil,
          slug: slug,
          url: url,
          relative_url: url + '/index.html'
        }
      end
    end

    return result
  end
end
