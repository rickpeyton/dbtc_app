Fabricator(:link) do
  link_day { Time.now.strftime("%Y/%m/%d") }
end
