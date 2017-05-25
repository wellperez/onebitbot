require_relative './../../spec_helper.rb'

describe FaqLinkModule::CreateService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    it "with list command: With zero faqs, return don't find message" do
      @listService = FaqLinkModule::ListService.new({"faq_links_type-original"=> rand(0..1)}, 'list')

      response = @listService.call()
      expect(response).to match("Nada encontrado")
    end

    it "With two faqs, find questions and answer in response" do
      @listService = FaqLinkModule::ListService.new({"faq_links_type-original"=> 0}, 'list')

      faq1 = create(:faq_link, company: @company,faq_links_type: 0)
      faq2 = create(:faq_link, company: @company,faq_links_type: 0)

      response = @listService.call()

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end

    it "with search command: With empty query, return don't find message" do
      @listService = FaqLinkModule::ListService.new({'query' => '', "faq_links_type-original"=> rand(0..1)}, 'search')

      response = @listService.call()
      expect(response).to match("Nada encontrado")
    end

    it "with search command: With wrong enum, return type error" do
      @listService = FaqLinkModule::ListService.new({'query' => '', "faq_links_type-original"=> rand(2..100)}, 'search')

      response = @listService.call()
      expect(response).to match("Parâmetros do tipo associado está errado.")
    end

    it "with search command: With empty enum, return type error" do
      @listService = FaqLinkModule::ListService.new({'query' => '', "faq_links_type-original"=> ""}, 'search')

      response = @listService.call()
      expect(response).to match('Parâmetros do tipo associado está errado.')
    end

    it "with search command: With nill enum, return type error" do
      @listService = FaqLinkModule::ListService.new({'query' => '', "faq_links_type-original"=> nil}, 'search')

      response = @listService.call()
      expect(response).to match("Parâmetros do tipo associado está errado.")
    end

    it "with search command: With valid query, find question and answer in response" do
      faq = create(:faq_link, company: @company, faq_links_type: 1)

      @listService = FaqLinkModule::ListService.new({'query' => faq.question.split(" ").sample, "faq_links_type-original"=> 1}, 'search')

      response = @listService.call()

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end

    it "with search_by_hashtag command: With invalid hashtag, return don't find message" do
      @listService = FaqLinkModule::ListService.new({'query' => '', "faq_links_type-original"=> 0}, 'search_by_hashtag')

      response = @listService.call()
      expect(response).to match("Nada encontrado")
    end

    it "with search_by_hashtag command: With valid hashtag, find question and answer in response" do
      faq = create(:faq_link, company: @company, faq_links_type: 1)
      hashtag = create(:hashtag, company: @company)
      create(:faq_link_hashtag, faq_link: faq, hashtag: hashtag)

      @listService = FaqLinkModule::ListService.new({'query' => hashtag.name, "faq_links_type-original"=> 1}, 'search_by_hashtag')

      response = @listService.call()

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end
end
