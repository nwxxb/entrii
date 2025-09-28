class TableSection < SitePrism::Section
  sections :rows, RowSection, "tr:has(td):not(:has(th))"
  elements :columns, "tr:first-child:has(th):not(:has(td)) th"

  def columns_text
    columns.map(&:text)
  end

  def rows_text
    rows.map(&:cells_text)
  end
end
