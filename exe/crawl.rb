require "#{ File.expand_path(File.dirname(__FILE__)) }/../models/article.rb"
require 'colorize'
require 'ostruct'
require 'pry'
require 'spidr'


MAX_ARTICLES_PER_SOURCE = 500

Article.delete_all

sources = [
  OpenStruct.new(
    name: :fox,
    starting_url: 'http://www.foxnews.com/politics.html',
    ignore_urls_like: ->(url) { !url.path.include?('/politics') },
    content_xpath: '//article | //*[@id="content"]',
  ),
  OpenStruct.new(
    name: :cnn,
    starting_url: 'http://www.cnn.com/politics',
    ignore_urls_like: ->(url) { !url.path.include?('/politics') },
    content_xpath: '//article',
  ),
  OpenStruct.new(
    name: :breitbart,
    starting_url: 'http://www.breitbart.com/big-government/',
    ignore_urls_like: ->(url) { !url.path.include?('/big-government') },
    content_xpath: '//article',
  ),
  OpenStruct.new(
    name: :vox,
    starting_url: 'http://www.vox.com/policy-and-politics',
    ignore_urls_like: ->(url) { !url.path.include?('/policy-and-politics') },
    content_xpath: '//article | //*[contains(@class, "l-main-content")]',
  ),
  OpenStruct.new(
    name: :huffpost,
    starting_url: 'http://www.huffingtonpost.com/section/politics',
    ignore_urls_like: ->(url) { !url.to_s.include?('politics') },
    content_xpath: '//article | //*[contains(@class, "l-main-content")]',
  ),
  OpenStruct.new(
    name: :wsj,
    starting_url: 'http://blogs.wsj.com/washwire/',
    ignore_urls_like: ->(url) { !url.path.include?('washwire') },
    content_xpath: '//article',
  ),
  OpenStruct.new(
    name: :wp,
    starting_url: 'https://www.washingtonpost.com/politics/',
    ignore_urls_like: ->(url) {
      !url.path.include?('/politics') || url.path.include?('_video.html')
    },
    content_xpath: '//*[@id="main-content"]',
  ),
  OpenStruct.new(
    name: :bloomberg,
    starting_url: 'https://www.bloomberg.com/politics',
    ignore_urls_like: ->(url) { !url.path.include? '/politics' },
    content_xpath: '//article',
  ),
  OpenStruct.new(
    name: :reuters,
    starting_url: 'http://www.reuters.com/politics',
    ignore_urls_like: ->(url) {
      ['/article', '/politics'].none? { |segment| url.path.include?(segment) }
    },
    ignore_pages_like: ->(page) {
      !page.search('//*[contains(@class, "article-section")]').try(:text).try(:include?, 'Politics')
    },
    content_xpath: '//*[@id="rcs-articleContent"]',
  ),
  OpenStruct.new(
    name: :townhall,
    starting_url: 'http://townhall.com/watchdog/',
    ignore_urls_like: ->(url) { !url.path.include?('/watchdog') },
    content_xpath: '//article',
  ),
  OpenStruct.new(
    name: :aljazeera,
    starting_url: 'http://www.aljazeera.com/topics/country/united-states.html',
    ignore_urls_like: ->(url) {
      ['/news', '/indepth', '/profile', '/programmes', 'united-states'].none? { |segment|
        url.path.include?(segment)
      }
    },
    ignore_pages_like: ->(page) {
      !page.search('//*[contains(@class, "FirstTopic")]').try(:text).try(:include?, 'United States')
    },
    content_xpath: '//*[@id="main-content"]',
  ),
]

def should_process_page?(page, source, page_count)
  return false unless page_count < MAX_ARTICLES_PER_SOURCE
  return false if source.ignore_pages_like&.call(page)
  true
end

def extract_content(page, xpath)
  page.search(xpath)
    .map(&:text)
    .join
    .tr("\t", ' ')
    .tr("\n", ' ')
    .tr("\r", ' ')
    .squeeze(' ')
end

sources.each do |source|
  Spidr.site(source.starting_url) do |agent|
    page_count = 0

    agent.every_url do
      if page_count >= MAX_ARTICLES_PER_SOURCE
        agent.skip_link!
      end
    end

    if source.ignore_urls_like
      agent.ignore_urls_like(&source.ignore_urls_like)
    end

    agent.every_page do |page|
      if should_process_page?(page, source, page_count)
        if text = extract_content(page, source.content_xpath).presence
          begin
            Article.create(category: source.name, text: text, url: page.url)
            page_count += 1
            puts "Successfully saved article at #{ page.url } (#{ page_count } of #{ MAX_ARTICLES_PER_SOURCE })".green
          rescue => e
            puts "Error saving article at #{ page.url }: #{ e }".red
          end
        else
          puts "Could not find article text for #{ page.url }".red
        end
      end
    end
  end
end