require 'spec_helper'

describe Video do
  it 'saves itself' do
    video = Video.create(title: 'monk', description: 'very nice', rating: 3.1, category_id: 2)
    video.save
    expect(Video.first).to eq(video)
  end
end