require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it "With zero faqs, return don't find message" do
      response = InterpretService.call('list', {"faq_links_type-original" => 0})
      expect(response).to match("Nada encontrado")
    end

    it "With two faqs, find questions and answer in response" do
      faq1 = create(:faq_link, company: @company, faq_links_type: 0)
      faq2 = create(:faq_link, company: @company, faq_links_type: 0)

      response = InterpretService.call('list', {"faq_links_type-original" => 0})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search', {"query": '', "faq_links_type-original"=> rand(0..1)})
      expect(response).to match("Nada encontrado")
    end

    it "With valid query, find question and answer in response" do
      faq = create(:faq_link, company: @company, faq_links_type: 0)

      response = InterpretService.call('search', {"query" => faq.question.split(" ").sample, "faq_links_type-original"=> 0})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by category' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_by_hashtag', {"query": '', "faq_links_type-original"=> 0})
      expect(response).to match("Nada encontrado")
    end

    it "With valid hashtag, find question and answer in response" do
      faq = create(:faq_link, company: @company, faq_links_type: 1)
      hashtag = create(:hashtag, company: @company)
      create(:faq_link_hashtag, faq_link: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', {"query" => hashtag.name, "faq_links_type-original"=> 0})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it "Without hashtag params, receive a error" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "faq_links_type-original" => rand(0..1)})
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original" => rand(0..1)})
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find question and anwser in database" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original" => rand(0..1)})
      expect(FaqLink.last.question).to match(@question)
      expect(FaqLink.last.answer).to match(@answer)
    end

    it "With valid params, hashtags are created" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original" => rand(0..1)})
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end

    it "With invalid params, receive error message" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(response).to match("Algo aconteceu com o tipo do registro. :(")
    end

    it "With invalid params in enum, receive error message" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original" => rand(2..100)})
      expect(response).to match("Problemas na criação")
    end


  end

  describe '#remove' do
    it "With valid ID, remove Faq" do
      faq = create(:faq_link, company: @company, faq_links_type: 1)
      response = InterpretService.call('remove', {"id" => faq.id})
      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      response = InterpretService.call('remove', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end
end
