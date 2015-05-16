@declension = (number, forms) ->
    cases = [2, 0, 1, 1, 1, 2]
    forms[ if number%100>4 && number%100<20 then 2 else cases[if number%10<5 then number%10 else 5] ]
