Fabricator(:category) do
  name { ['Drama', 'Comedy', 'Reality'].sample }
  title { ['TV Drama', 'TV Comedies', 'Reality TV'].sample }
end