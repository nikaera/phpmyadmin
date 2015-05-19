range=10;
number="";
for i in {0..18}; do
      r=$RANDOM;
      let "r %= $range";
      number="$number""$r";
done;
echo $number
