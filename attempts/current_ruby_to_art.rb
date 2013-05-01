x='a={5=>" ",12=>"0",9=>"p",4=>"l",3=>"e",14=>"a",7=>"F",8=>".",13=>"r",16=>"t",0=>"$",2=>"i",15=>"d",1=>"u",6=>"s"}'
y=[]
y<<x[0..1]
y<<x[2]

x=~/{(.+?)}/
between=$1
els=between.split ','
split_els=els.map do |e|
  e=~/(.+?=>)(.+)/
  [$1,"#{$2},"]
end
y.concat split_els.flatten
y<<x[-1]

require 'pry'; binding.pry

__END__

a=
{
5=>
" ",
12=>
"0",
9=>
"p",
4=>
"l",
3=>
"e",
14=>
"a",
7=>
"F",
8=>
".",
13=>
"r",
16=>
"t",
0=>
"$",
2=>
"i",
15=>
"d",
1=>
"u",
6=>
"s"
}
