10 A$="this was a film from oldskoolcoder (c) jun 2019. "
20 A$ = A$ + "github : https://github.com/oldskoolcoder/ "
40 A$ = A$ + "twitter : @oldskoolcoder email : oldskoolcoder@outlook.com "
50 A$ = A$ + "please support me on patreon @ https://www.patreon.com/"
60 A$ = A$ + "oldskoolcoder thank you ;-)"
100 print "{clear}"
110 for i = 1 to len(A$)
120 rem for sl = 1025 to 1063
130 rem poke sl-1, peek(sl)
140 rem next sl
145 print "{home}{right}{delete}";
150 print "{home}{right*39}"; mid$(A$,i,1);
155 for de = 1 to 100 : next
160 next i
