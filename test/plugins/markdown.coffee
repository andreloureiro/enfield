assert   = require "assert"
pygments = require "pygments"
sinon    = require "sinon"

{converters} = require "../../src/plugins/markdown"

describe "Markdown converter", ->
  sandbox = null
  beforeEach ->
    sandbox = sinon.sandbox.create()
  afterEach ->
    sandbox.restore()

  it "Matches .md and .markdown extensions", ->
    assert converters.markdown.matches(".md"), ".md"
    assert converters.markdown.matches(".markdown"), ".markdown"
    assert !converters.markdown.matches(".mdown"), ".mdown"

  it "Outputs .html extension", ->
    assert.equal converters.markdown.outputExtension('.md'), '.html'
    assert.equal converters.markdown.outputExtension('.markdown'), '.html'

  it "Converts markdown", (done) ->
    converters.markdown.convert "*Hello* **World**", (err, output) ->
      assert !err, "No error thrown"
      assert.equal output, "<p><em>Hello</em> <strong>World</strong></p>\n"
      done()

  it "Highlights code", (done) ->
    pygmentsOutput = '<div class="highlight"><pre>
<span class="kd">var</span> <span class="nx">foo</span> <span class="o">=</span>
 <span class="s2">&quot;bar&quot;</span><span class="p">;</span>\n
</pre></div>\n'
    expected = '<pre><code class="lang-js">
<span class="kd">var</span> <span class="nx">foo</span> <span class="o">=</span>
 <span class="s2">&quot;bar&quot;</span><span class="p">;</span>\n\n
</code></pre>\n'

    sandbox.stub(pygments, "colorize")
      .callsArgWithAsync(3, pygmentsOutput)

    md = """``` js
var foo = "bar";
```"""

    converters.markdown.convert md, (err, output) ->
      assert !err, "No error thrown"
      assert.equal output, expected
      done()
