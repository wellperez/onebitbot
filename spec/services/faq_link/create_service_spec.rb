require_relative './../../spec_helper.rb'

describe FaqLinkModule::CreateService do
  before do
    @company = create(:company)

    @question = FFaker::Lorem.sentence
    @answer = FFaker::Lorem.sentence
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do
    it "Without hashtag params, will receive a error" do
      @createService = FaqLinkModule::CreateService.new({"question-original" => @question, "answer-original" => @answer, "faq_links_type-original"=> rand(0..1)})

      response = @createService.call()
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      @createService = FaqLinkModule::CreateService.new({"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original"=> rand(0..1)})

      response = @createService.call()
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find question and anwser in database" do
      @createService = FaqLinkModule::CreateService.new({"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original"=> rand(0..1)})

      response = @createService.call()
      expect(FaqLink.last.question).to match(@question)
      expect(FaqLink.last.answer).to match(@answer)
    end

    it "With valid params, hashtags are created" do
      @createService = FaqLinkModule::CreateService.new({"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags, "faq_links_type-original"=> rand(0..1)})

      response = @createService.call()
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end
end
