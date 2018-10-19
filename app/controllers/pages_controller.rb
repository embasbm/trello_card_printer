require 'open-uri'
class PagesController < ApplicationController
  def index
    @card_data = params[:q]&.split(/\r\n/)&.map do |card_url|
       get_card_data(card_url.split('/')[4])
    end
  end


  def get_card_data(card_id)
    url = URI("https://api.trello.com/1/cards/#{card_id}?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}")

    read_body = open(url).read
    parsed_body = JSON.parse(read_body)
    {
      title: parsed_body['name'],
      description: parsed_body['desc'],
      labels: parsed_body['labels'].collect {|x| x.slice('name','color')},
      checklists: fetch_checklists(parsed_body['idChecklists']),
      url_of_the_card: parsed_body['shortUrl'],
    }
  end

  def fetch_checklists(checklists)
    result_checklist = []
    checklists.each do |checklist_id|
      url = URI("https://api.trello.com/1/checklists/#{checklist_id}?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}")

      read_body = open(url).read
      parsed_body = JSON.parse(read_body)
      my_hash = {
        name: parsed_body['name'],
        items: parsed_body['checkItems'].collect {|x| x.slice('name', 'state')},
      }
      result_checklist << my_hash
    end
    result_checklist
  end
end
