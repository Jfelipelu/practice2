# 📚 Vehicle sales system (Prolog)

A SWI-Prolog vehicle catalog showcasing findall/3 & bagof/3 queries plus a price-sorted report that picks the cheapest items without exceeding a global cap.

---

## 👥 Integrant

- **Juan Felipe Gallón Maldonado**

---

1) **Catalog** of ≥10 vehicles as `vehicle/5` facts.  
2) **Queries** using `findall/3` and `bagof/3`.  
3) **Report** that prioritizes the cheapest items without exceeding a **global cap**.

---

## 💻 Requirements and platform

- **SWI-Prolog** (tested with swipl 9.x on Windows).

---

## 🗂️ Files

- `practice2.pl` — main code:
  - Facts: `vehicle/5`
  - Predicates: `meet_budget/2`, `references_by_brand/2`, `inventory_limit/1`, `generate_report/4`
  - Helpers: `select_under_cap/5`, `extract_refs/2`

## Included data (`vehicle/5`)

```prolog
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
```

## Loading the project

1) Open SWI-Prolog in your project folder.  
2) Load the file:

```prolog
?- [practice2].            % or consult('practice2.pl')
?- listing(vehicle/5).   % verify the facts are loaded
```

---

## Main predicates

### `vehicle/5`
Structure:
```
vehicle(Brand, Reference, Type, PriceUSD, Year).
```

### `meet_budget/2`
```
meet_budget(+Reference, +BudgetMax)
```
True if the given reference has unit price **≤ BudgetMax**.

### `references_by_brand/2`
```
references_by_brand(+Brand, -Refs:list)
```
Builds (via `findall/3`) the list of references for a brand.

### `inventory_limit/1`
```
inventory_limit(-Limit)
```
Global **inventory value cap** used by the report selection.

### `generate_report/4`
```
generate_report(+Brand, +Type, +Budget, -Result)
```
1. Filters by `Brand` and `Type` with **unit price ≤ Budget**.  
2. Sorts ascending by price.  
3. Selects the **prefix** that **does not exceed** the global cap (`inventory_limit/1`).  
4. Returns the selected references and the accumulated total.

### Helpers

#### `select_under_cap/5`
```
select_under_cap(+PairsSorted, +Acc, +Cap, -Selected, -Total)
```
- `PairsSorted` is a **price-sorted** list of `Price-Ref` pairs.
- Walks from cheapest to most expensive, **accumulating** while the running sum (`Acc`) stays within `Cap`.
- Returns the **maximal prefix** that fits and its `Total`.

#### `extract_refs/2`
```
extract_refs(+Pairs, -Refs)
```
Extracts only the references from a `Price-Ref` list.

---

### (Quick report example with the global cap)
```prolog
?- generate_report(toyota, suv, 30000, R).
% R = report([rav4], 28000).
```

---

## Showing prices in your outputs

If you want the queries to **include price**, use a template like `Price-Ref`.

Example of Case 1 **with** prices:
```prolog
?- findall(Price-Ref,
           (vehicle(toyota, Ref, suv, Price, _), Price < 30000),
           Result).
% Result = [28000-rav4].
```

---

