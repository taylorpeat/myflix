require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: 'comedy')
    category.save
    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    comedy = Category.create(name: 'comedy')
    south_park = Video.create(title: 'south_park', category_id: comedy.id)
    futurama = Video.create(title: 'futurama', category_id: comedy.id)
    expect(comedy.videos).to eq([futurama, south_park])
  end
end