module TumblrHelper

  @@URL = 'davemelvin.tumblr.com/'
  @@oauth= {
    :consumer_key => 'okVDv8hiO5R0JakfN3aR8mbZKwoJKBA9M3usu1tj7aEKi2dVm6',
    :consumer_secret => 'jQUNSQT6mzfyTKnSc8MT5BosZoCowG9oo7BzyhzeJ7b1r3jD4B',
    :oauth_token =>  'mR312aJDKiSyzNkfi3qcAE8JNT0onIKDv8Ar9QzAdNmqXNf0am',
    :oauth_token_secret => 'uM2YmI1EbI2dxrpPHhPhtrDdNGsax2TRuoMXtFAChh5YEXlQIl'
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
