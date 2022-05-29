  SELECT
    dates.DsDate,
    counties.DsCountyName,
    stores.DsStoreName,
    vendors.DsVendorName,
    categories.DsCategoryName,
    products.DsProductName,
    sales.CdSale,
    sales.QtBottlesSold,
    sales.VrSalesDollars,
    sales.VrVolumeSoldLiters
  FROM covid19retail_app.fact_sales AS sales
  JOIN covid19retail_app.dim_stores AS stores
    ON sales.CdStore = stores.CdStore
  JOIN covid19retail_app.dim_counties AS counties
    ON stores.CdCounty = counties.CdCounty
  JOIN covid19retail_app.dim_dates AS dates
    ON sales.CdDate = dates.CdDate
  LEFT JOIN covid19retail_app.dim_products AS products
    ON sales.CdProduct = products.CdProduct
  LEFT JOIN covid19retail_app.dim_categories AS categories
    ON products.CdCategory = categories.CdCategory
  LEFT JOIN covid19retail_app.dim_vendors AS vendors
    ON products.CdVendor = vendors.CdVendor
