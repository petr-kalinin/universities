renderer = new marked.Renderer()

renderer.originalHeading = renderer.heading

renderer.heading = (text, level, raw) -> 
    @originalHeading(text, level + 3, raw)
    
marked.setOptions
  renderer: renderer,
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: true,
  smartLists: true,
  smartypants: false
