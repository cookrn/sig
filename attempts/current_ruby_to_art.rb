x='a={5=>" ",12=>"0",9=>"p",4=>"l",3=>"e",14=>"a",7=>"F",8=>".",13=>"r",16=>"t",0=>"$",2=>"i",15=>"d",1=>"u",6=>"s"}'
y=[]
t=true
f=false

y<<[x[0],f]
y<<[x[1],t]
y<<[x[2],t]

x=~/{(.+?)}/
between=$1
els=between.split ','
split_els=els.reduce [] do |m,e|
  e=~/(.+?)(=>)(.+)/
  m << [$1,f]
  m << [$2,t]
  m << [$3,f]
  m << [',',t]
  m
end
y.concat split_els
y<<[x[-1],t]

art = <<___
                   iiii
                  i::::i
                   iiii
    ssssssssss   iiiiiii    ggggggggg   ggggg
  ss::::::::::s  i:::::i   g:::::::::ggg::::g
ss:::::::::::::s  i::::i  g:::::::::::::::::g
s::::::ssss:::::s i::::i g::::::ggggg::::::gg
 s:::::s  ssssss  i::::i g:::::g     g:::::g
   s::::::s       i::::i g:::::g     g:::::g
      s::::::s    i::::i g:::::g     g:::::g
ssssss   s:::::s  i::::i g::::::g    g:::::g
s:::::ssss::::::si::::::ig:::::::ggggg:::::g
s::::::::::::::s i::::::i g::::::::::::::::g
 s:::::::::::ss  i::::::i  gg::::::::::::::g
  sssssssssss    iiiiiiii    gggggggg::::::g
                                     g:::::g
                         gggggg      g:::::g
                         g:::::gg   gg:::::g
                          g::::::ggg:::::::g
                           gg:::::::::::::g
                             ggg::::::ggg
                                ggggg
___

new_art = ''

art.lines.each do | line |
  new_line =
    line.gsub /\S+/ do | match |
      char = '!'
      new_str = ''
      match.size.times do
        new_str << char
      end
      new_str
    end

  new_art << new_line
end

require 'pry'; binding.pry

__END__

a        =
{
5        =>
" "      ,
12       =>
"0"      ,
9        =>
"p"      ,
4        =>
"l"      ,
3        =>
"e"      ,
14       =>
"a"      ,
7        =>
"F"      ,
8        =>
"."      ,
13       =>
"r"      ,
16       =>
"t"      ,
0        =>
"$"      ,
2        =>
"i"      ,
15       =>
"d"      ,
1        =>
"u"      ,
6        =>
"s"
}
