class RowSection < SitePrism::Section
  elements :cells, "td"

  def cells_text
    cells.map(&:text)
  end
end
