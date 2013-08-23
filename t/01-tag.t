use Test::More;
BEGIN {
        use_ok( 'HTML::TagHelper' );
}

my $th = HTML::TagHelper->new;

# Tags
is $th->t('foo'), '<foo />', 'basic tag';
is $th->t('foo', bar => 'baz'), '<foo bar="baz" />', 'tag with attrs';
is $th->t('foo', one => 't<wo'), '<foo one="t&lt;wo" />', 'tag with escape attr';
is $th->t( 'bar', class => 'test', 0), '<bar class="test">0</bar>', 'tag with content';
is $th->tag( bar => 'b<a>z'), '<bar>b&lt;a&gt;z</bar>', 'long method name tag';

# Links
is $th->link_to('Pa<th' => '/path'), '<a href="/path">Pa&lt;th</a>', 'links with excape content';
is $th->link_to('http://example.com/', title => 'Foo', sub { 'Foo' }), '<a href="http://example.com/" title="Foo">Foo</a>', 'links with content returned by sub';

# javascript
is $th->js('/bootstrap.js'), '<script languages="javascript" src="/bootstrap.js" type="text/javascript" />', 'js';
is $th->js('amcharts/ammap'), '<script languages="javascript" src="/javascripts/amcharts/ammap.js" type="text/javascript" />', 'short js in public/';

# css
is $th->css('/bootstrap.css'), '<link href="/bootstrap.css" rel="stylesheet" type="text/css" />', 'css';
is $th->css('amcharts/style'),'<link href="/css/amcharts/style.css" rel="stylesheet" type="text/css" />', 'short css in public/';

# form
is $th->form_for('/links', sub {
    return $th->text_field(foo => 'bar')
    . $th->input_tag(baz => 'yada', class => 'tset')
    . $th->submit_button
}), '<form action="/links"><input name="foo" type="text" value="bar" /><input class="tset" name="baz" type="" value="yada" /><input type="submit" value="Ok" /></form>', 'form_for with text, input and submit';

# date
is $th->date_select_field('date',{year_start => 2013, year_end => 2013}), '<select id="date_day" name="date_day"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option selected="true" value="23">23</option><option value="24">24</option><option value="25">25</option><option value="26">26</option><option value="27">27</option><option value="28">28</option><option value="29">29</option><option value="30">30</option><option value="31">31</option></select><select id="date_month" name="date_month"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option selected="true" value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option></select><select id="date_year" name="date_year"><option selected="true" value="2013">2013</option></select>', 'date_select_field';

# select
my $exp_opt_sel =<<EOF;
<option value="option1">Option 1</option>
<option value="option2">Option 2</option>
EOF
is $th->options_for_select( [{title => "Option 1", value => "option1"}, {title => "Option 2", value => "option2"}] ), $exp_opt_sel, 'options_for_select';

my $exp_opt_sltd =<<EOF;
<option selected="true" value="option1">Option 1</option>
<option value="option2">Option 2</option>
EOF
is $th->options_for_select( [{title => "Option 1", value => "option1"}, {title => "Option 2", value => "option2"}], ['option1']), $exp_opt_sltd, 'options_for_selected';

is $th->select_field('test'),'<select id="test" name="test"></select>','basic select_field';
is $th->select_field('test', [], {class => 'test'}),'<select class="test" id="test" name="test"></select>','select with class';

my $exp_sel = '<select id="test" name="test"><option value="option1">Option 1</option>' . "\n"
            . '<option value="option2">Option 2</option>' . "\n"
            . '</select>';
is $th->select_field('test', [{title => "Option 1", value => "option1"}, {title => "Option 2", value => "option2"}]), $exp_sel, 'select with options';

# radio
is $th->form_for('/radio', sub {
    return $th->radio_button(b => 1)
    . $th->radio_button(a => 0)
    . $th->submit_button('what')
}), '<form action="/radio"><input name="b" type="radio" value="1" /><input name="a" type="radio" value="0" /><input type="submit" value="what" /></form>', 'form_for with radio and named submit';

# checkbox
is $th->form_for('/multibox', sub {
    return $th->check_box(foo => 'one')
    . $th->check_box(foo => 'two')
}), '<form action="/multibox"><input name="foo" type="checkbox" value="one" /><input name="foo" type="checkbox" value="two" /></form>', 'form_for with checkbox';

# textarea
is $th->textarea('bar', cols => 40), '<textarea cols="40" name="bar" />', 'simple textarea';
is $th->textarea(foo => 'b<z>r', cols => 40), '<textarea cols="40" name="foo">b&lt;z&gt;r</textarea>', 'textarea with escape content';
is $th->textarea(e => (cols => 40, rows => 50) => sub {'text in textarea'}), '<textarea cols="40" name="e" rows="50">text in textarea</textarea>', 'textarea with content returned by sub';

done_testing;
