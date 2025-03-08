require 'hexapdf'

doc = HexaPDF::Document.new
page = doc.pages.add
canvas = page.canvas

canvas.font('Helvetica', size: 50)
      .fill_color(0, 128, 255)
canvas.text('Hello, World!', at: [20, 400])
doc.write('hello.pdf')
