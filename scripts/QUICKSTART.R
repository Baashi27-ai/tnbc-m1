message('Quickstart: open master index and DOCX if present')
 idx <- 'C:/TNBC_project/results/TNBC_M1_master_index.html'
 doc <- 'C:/TNBC_project/results/REPORTS/TNBC_M1_summary.docx'
 if (file.exists(idx)) utils::browseURL(idx) else message('Index not found yet')
 if (file.exists(doc)) utils::browseURL(doc) else message('DOCX not found yet')
