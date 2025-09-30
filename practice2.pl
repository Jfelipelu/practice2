vehicle(toyota, rav4, suv, 28000, 2023).
vehicle(toyota, prado, suv, 40000, 2023).
vehicle(toyota, fortuner, suv, 36000, 2022).
vehicle(toyota, corolla, sedan, 22000, 2022).
vehicle(ford, mustang, sport, 45000, 2023).
vehicle(ford, f150, pickup, 40000, 2024).
vehicle(ford, focus, sedan, 20000, 2020).
vehicle(bmw, x5, suv, 60000, 2021).
vehicle(bmw, serie330i, sedan, 42000, 2021).
vehicle(honda, civic, sedan, 21000, 2021).
vehicle(chevrolet, silverado, pickup, 42000, 2023).
vehicle(mazda, cx5, suv, 29000, 2024).

meet_budget(Reference, BudgetMax) :-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.

references_by_brand(Brand, Refs) :-
    findall(Ref, vehicle(Brand, Ref, _, _, _), Refs).


group_by_brand_type_year(Brand, Groups) :-
    (bagof((Type,Year,Refs),
        bagof(Ref, vehicle(Brand, Ref, Type, _, Year), Refs),
        Groups)
    ->  true
    ;   Groups = []).

inventory_limit(1000000).

generate_report(Brand, Type, Budget, report(Refs, Total)) :-
    inventory_limit(Limit),
    findall(Price-Ref,
        ( vehicle(Brand, Ref, Type, Price, _),
            Price =< Budget ),
        Pairs0),
    keysort(Pairs0, Sorted),
    select_under_cap(Sorted, 0, Limit, Sel, Total),
    extract_refs(Sel, Refs).

select_under_cap([], Acc, _, [], Acc).
select_under_cap([P-R|T], Acc, Cap, Out, Total) :-
    Acc1 is Acc + P,
    (Acc1 =< Cap ->
        Out = [P-R|Out1],
        select_under_cap(T, Acc1, Cap, Out1, Total)
    ;Out = [],
    Total = Acc).

extract_refs([], []).
extract_refs([_-R|T], [R|RT]) :- extract_refs(T, RT).
