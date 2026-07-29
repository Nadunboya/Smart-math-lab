-- Seeds real Grade 6 units/concepts/short notes, sourced from the official
-- Sri Lankan Educational Publications Department textbook (Mathematics
-- Grade 6, Parts I & II — freely distributed, ISBN 978-955-25-0076-3 /
-- 978-955-25-0077-0). Run after supabase_content_schema.sql.
--
-- Covers 21 of the syllabus's 25 chapters. Four are intentionally excluded
-- because their teaching method is fundamentally hands-on/tool-based and
-- doesn't translate to a text+diagram e-learning format: Circles (paper
-- folding/tracing), Angles (protractor measurement), Rectilinear Plane
-- Figures (ruler/compass construction), and Solids (3D models/net-folding).
-- Those are better taught in the physical classroom.
--
-- Re-running this file is safe: it deletes existing Grade 6 units first
-- (cascading to their concepts/short_notes), then reinserts everything
-- fresh — this also replaces the placeholder mock content from the
-- original version of this file.
--
-- Grades 7+ are still empty on purpose (see supabase_content_schema.sql).

delete from public.units where grade = 6;

-- Grade 6 curriculum seed (batch 1): Place Value, Mathematical Operations on
-- Whole Numbers, and Time.
--
-- Source: "Grade 6 Mathematics, Pupil's Book, Part I", Educational
-- Publications Department, Sri Lanka (ISBN 978-955-25-0076-3), English
-- medium edition. Content is paraphrased from the printed chapters; no
-- Sinhala name is given since this is the English-medium edition.
--
-- Run after supabase_content_schema.sql.

do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Place Value', null, '#5B4FE5', 'hash', 'Learn to identify the place value of each digit in a whole number, find the value it represents, and read and write large numbers up to the billions period.', 0)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '2.1 Place Value', 'How the position of a digit in a number, the ones place or tens place, decides both its name and its value.', '## Place Value

When writing numbers, we most often use the **Hindu-Arabic number system**. In this system, the ten digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9 are used to write numbers.

- Numbers from **zero to nine** are written using one digit in **one position**. The greatest number that can be written using only one position is 9.
- The number one greater than nine is ten. Every number **from ten to ninety-nine** is written using **two positions** (either two distinct digits, or the same digit twice).

For example, the digits 3 and 5 arranged in two positions form different numbers:
- 35 is read as "thirty five"
- 53 is read as "fifty three"

The numbers are different because the position of each digit has changed.

### Ones place and tens place

Thirty-five beads, threaded into chains of ten beads each, form 3 chains of ten with 5 beads left over:

Thirty five = 3 tens + 5 ones = 35

- The 5 in 35 represents 5 ones. The position it occupies is the **ones place**. The place value of the ones place is 1.
- The 3 in 35 represents 3 tens. The position it occupies is the **tens place**. The place value of the tens place is 10.

In the same way:
- 53 = 5 tens + 3 ones = 50 + 3
- 65 = 6 tens + 5 ones = 60 + 5
- 99 = 9 tens + 9 ones = 90 + 9

**There is a value represented by a digit in a number, according to the position of the digit.**

- The value represented by 3 in 35 = 3 tens = 30
- The value represented by 5 in 35 = 5 ones = 5

**Key facts:**
- The maximum value that can be represented by a digit in the ones place is 9.
- The maximum value that can be represented by a digit in the tens place is 90.
- The maximum number of counters that can be placed on a single rod of an abacus is 9.

**Example**

| Number | Digit | Name of the position | Value represented by the digit |
|---|---|---|---|
| 45 | 4 | Tens place | 40 |
| 45 | 5 | Ones place | 5 |
| 30 | 0 | Ones place | 0 |', 0),
    (uid, '2.2 Place Value Described Further', 'Extending place value through the hundreds, thousands and ten thousands places, including the value of each digit in a five-digit number.', '## Place Value Described Further

The greatest number that can be written using two positions is 99 (9 tens and 9 ones). The number one greater than 99 is a hundred, and the tens and ones places alone are not enough to write it in digits.

- The place value of the position to the left of the tens place is 100, and that position is named the **hundreds place**.
- Hundred is written using three positions as 100.

| Number | Hundreds | Tens | Ones |
|---|---|---|---|
| 100 | 1 | 0 | 0 |

### Numbers with three positions

Consider the digits 2, 4 and 5 arranged to form three-digit numbers, and look at what 5 represents in each:

- 245 -> 5 is in the ones place -> value represented by 5 = 5 ones = 5
- 254 -> 5 is in the tens place -> value represented by 5 = 5 tens = 50
- 524 -> 5 is in the hundreds place -> value represented by 5 = 5 hundreds = 500

The value represented by a digit changes according to its position.

**Key facts:**
- The place value corresponding to the position of each digit in a number, from right to left, is respectively 1, 10, 100, 1000, 10000, and so on.
- When two successive digits of a number are considered, the place value of the position on the left is **ten times** the place value of the position on the right.

### Extending to five positions

In the number 67524, each digit occupies a named position:

| Position | Ten thousands | Thousands | Hundreds | Tens | Ones |
|---|---|---|---|---|---|
| Digit | 6 | 7 | 5 | 2 | 4 |

67524 = 6 ten thousands + 7 thousands + 5 hundreds + 2 tens + 4 ones

The value represented by each digit:
- 4 (ones place) -> 4
- 2 (tens place) -> 20
- 5 (hundreds place) -> 500
- 7 (thousands place) -> 7000
- 6 (ten thousands place) -> 60000

**Example:** Write down the value represented by each digit in 5968.
- Value represented by 8 = 8 ones = 8
- Value represented by 6 = 6 tens = 60
- Value represented by 9 = 9 hundreds = 900
- Value represented by 5 = 5 thousands = 5000', 1),
    (uid, '2.3 Periods of Numbers', 'Splitting long numbers into periods, units, thousands, millions and billions, to read and write them in standard form and in words.', '## Periods of Numbers

Large numbers are easier to read when split into groups of three digits, starting from the ones place and moving left. Each group is called a **period** (or number zone) — the left-most period may have fewer than three digits.

For example, 2836696 is separated as 2 836 696, with periods named (right to left): **units period**, **thousands period**, **millions period**.

2836696 is read as: two million eight hundred thirty six thousand six hundred ninety six.

Larger numbers add further periods:
- 7686975623 has four periods: **billions period**, millions period, thousands period, units period (the billions period is the period after the millions period). Separated: 7 686 975 623. Read as: seven billion six hundred eighty six million nine hundred seventy five thousand six hundred twenty three.
- 675278285676, separated as 675 278 285 676, is read as: six hundred seventy five billion two hundred seventy eight million two hundred eighty five thousand six hundred seventy six.

### Standard form

Writing a number by separating it into periods of three digits, starting from the ones place and moving left, is called representing the number in **standard form**. A small space (in some cases a comma) is left between periods.

| General form | Standard form |
|---|---|
| 2854375 | 2 854 375 |
| 43529644 | 43 529 644 |
| 204007800 | 204 007 800 |
| 8430000000 | 8 430 000 000 |

The way a number is read or written in words is called the **name of the number**. In most financial documents, an amount is written down in words.

**For extra knowledge — other names used for large numbers:**

| Number | Name of the number | Other name used |
|---|---|---|
| 100 000 | Hundred thousand | Lakh |
| 1 000 000 | Million | Ten lakhs |
| 10 000 000 | Ten million | Crore |
| 100 000 000 | Hundred million | Ten crores |', 2);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'The value a digit represents depends on its position: the same digit means something different in the ones, tens or hundreds place', 0),
    (uid, 'Place value from right to left goes 1, 10, 100, 1000, 10 000 and so on, each ten times the one before it', 1),
    (uid, 'Long numbers are split into periods of three digits, units, thousands, millions, billions, to make them easy to read', 2),
    (uid, 'Standard form separates a number into periods with a small space or comma, e.g. 2 836 696', 3);
end $$;

-- 2. Mathematical Operations on Whole Numbers
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Mathematical Operations on Whole Numbers', null, '#8B5CF6', 'ops', 'Learn methodical ways to add, subtract, multiply and divide whole numbers, including quick rules for multiplying and dividing by 10, 100 and 1000.', 1)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '3.1 Adding Whole Numbers', 'Adding whole numbers place by place, carrying over into the next column when a total reaches ten.', '## Adding Whole Numbers

Numbers such as 0, 1, 2, 3, 4, and so on are known as **whole numbers**.

When adding whole numbers, the digits in each place, ones, tens, hundreds, and so on, are added separately. For example, 12 + 13 = 25: adding the ones (2 + 3 = 5) and the tens (1 + 1 = 2) separately gives 25.

### Adding with carrying

When the digits in a place add up to 10 or more, the extra ten(s) is carried over to the next place to the left.

**Example:** Simplify 4768 + 3986.

- Step 1 - Add the ones: 8 + 6 = 14. Write 4 in the ones place, carry 1 ten to the tens column.
- Step 2 - Add the tens: 1 + 6 + 8 = 15 tens. Write 5 in the tens place, carry 1 hundred to the hundreds column.
- Step 3 - Add the hundreds: 1 + 7 + 9 = 17 hundreds. Write 7 in the hundreds place, carry 1 thousand to the thousands column.
- Step 4 - Add the thousands: 1 + 4 + 3 = 8. Write 8 in the thousands place.

4768 + 3986 = 8754

**Example:** 627 + 283 = 910', 0),
    (uid, '3.2 Subtracting Whole Numbers', 'Subtracting whole numbers place by place, borrowing from the next column when a digit is too small.', '## Subtracting Whole Numbers

As with addition, subtraction of whole numbers is carried out separately for each place, ones, tens, hundreds, and so on.

**Example:** 25 - 12 = 13. Subtracting the ones (5 - 2 = 3) and the tens (2 - 1 = 1) separately gives 13.

### Subtracting with borrowing

When the digit being subtracted in a place is bigger than the digit above it, one unit is borrowed from the next place to the left.

**Example:** Simplify 6753 - 1896.

- Step 1 - Subtract the ones: 3 is less than 6, so borrow 1 ten (10 ones) from the tens place, making 13 ones. 13 - 6 = 7 ones.
- Step 2 - Subtract the tens: the 4 tens remaining is less than 9, so borrow 1 hundred (10 tens) from the hundreds place, making 14 tens. 14 - 9 = 5 tens.
- Step 3 - Subtract the hundreds: the 6 hundreds remaining is less than 8, so borrow 1 thousand (10 hundreds) from the thousands place, making 16 hundreds. 16 - 8 = 8 hundreds.
- Step 4 - Subtract the thousands: the 5 thousands remaining, minus 1 thousand, is 4 thousands.

6753 - 1896 = 4857

**Example:** 76 - 41 = 35', 1),
    (uid, '3.3 Multiplying Whole Numbers', 'Multiplication as repeated addition, and using a multiplication table for quick single-digit products.', '## Multiplying Whole Numbers

Multiplication is repeated addition. Three groups of 5 guavas each gives 5 + 5 + 5 = 15 guavas in total, written as 5 x 3 = 15.

Similarly:
- 2 + 2 + 2 + 2 + 2 = 2 x 5 = 10
- 10 + 10 + 10 + 10 = 10 x 4 = 40

**5 x 3 = 3 x 5** - three groups of five, when regrouped into groups of three, give five groups. Multiplying two whole numbers in either order gives the same product.

A multiplication table of the whole numbers from 0 to 9 gives the product of any two such digits directly, for example 5 x 3 = 15, 7 x 6 = 42, 9 x 8 = 72.

For a bigger number such as 34 x 2, which is not directly in the table, 34 is multiplied by the value represented by each of its digits, and the results are added:
- 4 (ones place of 34) x 2 = 8 ones = 8
- 3 (tens place of 34) x 2 = 6 tens = 60
- 8 + 60 = 68

So 34 x 2 = 68.', 2),
    (uid, '3.4 Multiplying by 10, 100 and 1000', 'Quick rules for multiplying a whole number by 10, 100 or 1000.', '## Multiplying by 10, 100 and 1000

Consider:
- 2 x 10 = 10 twos = 2 tens = 20
- 2 x 100 = 100 twos = 2 hundreds = 200
- 2 x 1000 = 1000 twos = 2 thousands = 2000
- 12 x 10 = 10 twelves = 12 tens = 100 + 20 = 120

More examples: 3 x 10 = 30, 3 x 100 = 300, 3 x 1000 = 3000; 7 x 10 = 70, 7 x 100 = 700, 7 x 1000 = 7000; 15 x 10 = 150, 15 x 100 = 1500, 15 x 1000 = 15 000.

**Key facts, found by examining the products above:**
- Multiplying a number by 10 gives the number with **1 zero** placed at its right end.
- Multiplying a number by 100 gives the number with **2 zeros** placed at its right end.
- Multiplying a number by 1000 gives the number with **3 zeros** placed at its right end.', 3),
    (uid, '3.5 Multiplication Described Further', 'Multiplying multi-digit numbers by breaking one number into its place values and adding the partial products.', '## Multiplying Multi-Digit Numbers

To multiply 25 x 14, think of it as 14 twenty-fives, which is 10 twenty-fives plus 4 twenty-fives.
- 10 twenty-fives = 250
- 4 twenty-fives = 100
- 25 x 14 = 250 + 100 = 350

25 has been multiplied by the value represented by each digit of 14 (4 and 10), and the results have been added.

Written as long multiplication:

```
   25
 x 14
  100   (25 x 4 = 100)
  250   (25 x 10 = 250)
  350
```

**Example:** Evaluate 64 x 36.
- 64 x 6 = 384
- 64 x 30 = 1920
- 384 + 1920 = 2304

**Example:** Evaluate 157 x 52.
- 157 x 2 = 314
- 157 x 50 = 7850
- 314 + 7850 = 8164

Usually, when finding the product of two numbers, the larger number is multiplied by the smaller number.', 4),
    (uid, '3.6 Dividing Whole Numbers', 'Division as sharing a quantity into equal groups, including quotient and remainder.', '## Dividing Whole Numbers

Dividing means sharing a quantity equally into groups. If 10 olives are divided equally between two friends, each receives 5, described as "10 divided by 2", written 10 ÷ 2 = 5.

This can also be seen as 10 = 5 x 2, so 10 ÷ 2 = 5 — there are 2 groups of 5 in 10.

### Division with a remainder

If 7 buttons are divided equally between 2 friends, each gets 3 buttons, with 1 button left over. That is, 7 ÷ 2 is 3 with a remainder of 1.

**Long division for 7 ÷ 2:**
- 7 contains at most 3 twos, and 3 x 2 = 6.
- 7 - 6 = 1, the remainder.
- Quotient = 3, remainder = 1.

**Facts about zero:**
- When any number is multiplied by zero, the answer is zero (for example, 2 x 0 = 0, 412 x 0 = 0).
- When zero is divided by any number other than zero, the answer is zero (for example, 0 ÷ 13 = 0).
- **No number can be divided by zero.**', 5),
    (uid, '3.7 Dividing by 10, 100 and 1000', 'Quick rules for dividing a whole number by 10, 100 or 1000.', '## Dividing by 10, 100 and 1000

- 20 ÷ 10 means "how many tens are there in 20?" Since 2 x 10 = 20, 20 ÷ 10 = 2.
- 200 ÷ 100 means "how many hundreds are there in 200?" 200 ÷ 100 = 2.
- 2000 ÷ 1000 means "how many thousands are there in 2000?" 2000 ÷ 1000 = 2.

More examples: 30 ÷ 10 = 3, 400 ÷ 10 = 40, 3000 ÷ 1000 = 3, 15000 ÷ 100 = 150, 700 ÷ 100 = 7, 7000 ÷ 1000 = 7, 520 ÷ 10 = 52.

**Key facts, found by examining the divisions above:**
- A number ending in one zero, divided by 10, is found by removing that zero.
- A number ending in two zeros, divided by 100, is found by removing those 2 zeros.
- A number ending in three zeros, divided by 1000, is found by removing those 3 zeros.', 6),
    (uid, '3.8 Long Division Described Further', 'Using the long division method to divide whole numbers, including division by two-digit numbers.', '## Long Division

**Example:** Find 75 ÷ 5 using long division.
- Step 1 - The tens digit of 75 is 7. 7 ÷ 5 = 1 remainder 2 (2 tens remaining).
- Step 2 - Bring down the 5 ones to the remaining 2 tens, making 25 ones.
- Step 3 - 25 ÷ 5 = 5. So 75 ÷ 5 = 15.

### Dividing by a two-digit number

38 ÷ 12 - there are no twelves in 3, so find how many twelves are in 38. There are 3 twelves in 38 (3 x 12 = 36), with 2 remaining. So 38 ÷ 12 is 3 with a remainder of 2.

**Example:** Simplify:
- 470 ÷ 10 = 47 (10 x 47 = 470)
- 253 ÷ 11 = 23 (11 x 23 = 253)
- 419 ÷ 13 = 32 remainder 3 (13 x 32 = 416, 419 - 416 = 3)

A division can be checked using: quotient x divisor + remainder = the original number.', 7);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Add or subtract whole numbers place by place, ones, then tens, then hundreds, carrying or borrowing between columns as needed', 0),
    (uid, 'To multiply a multi-digit number, multiply by the value represented by each digit of the other number, then add the results', 1),
    (uid, 'Multiplying by 10, 100 or 1000 adds that many zeros to the end of a number; dividing by them removes that many zeros', 2),
    (uid, 'No number can ever be divided by zero, but zero divided by any other number is always zero', 3);
end $$;

-- 3. Time
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Time', null, '#3B82F6', 'int', 'Learn to read a clock accurately, use the 24-hour international time format, write dates in standard form, convert between seconds, minutes, hours and days, and find elapsed time.', 2)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '4.1 Reading a 12-Hour Clock Accurately', 'How the hour, minute and second hands work, and reading a 12-hour clock accurately, down to the second.', '## Reading a 12-Hour Clock Accurately

On a clock face:
- The circular edge is divided into 60 equal parts by short line segments.
- The numbers 1 to 12 are marked around the face, with five equal parts between any two adjacent numbers.
- Of the three hands fixed at the centre, the **hour hand** is the shortest, the narrow hand is the **seconds hand**, and the remaining hand is the **minute hand**. All three hands rotate in the direction the numbers on the face increase.

**Key facts:**
- 1 hour = 60 minutes (the time it takes the minute hand to complete one round)
- 1 minute = 60 seconds (the time it takes the seconds hand to complete one round)
- The hour is read as the number the hour hand is pointing towards or has last passed.
- The minutes and seconds are read as the line segment each hand has last passed or is pointing towards.

**Example:** If the hour hand lies between 10 and 11 (having last passed 10), the minute hand has last passed the 25th line segment, and the seconds hand points to the 13th segment, the time is read as 25 minutes and 13 seconds past 10, written 10.25.13. When the seconds are not needed, it is written simply as 10.25.

### a.m. and p.m.

- When all three hands of a clock point at 12 during the day, the time is **12 noon**.
- When all three hands point at 12 during the night, the time is **12 midnight**.
- The 12-hour period between midnight and noon is called **ante meridiem (a.m.)**, meaning "before midday".
- The 12-hour period between noon and midnight is called **post meridiem (p.m.)**, meaning "after midday".
- One day = 2 periods = 24 hours, since the hour hand completes two full rounds of the clock in a day.', 0),
    (uid, '4.2 Reading a 24-Hour Clock', 'Converting 12-hour clock times into the 24-hour international standard form, hh:mm:ss.', '## Reading the Time on a 24-Hour Clock

A 24-hour clock face marks the numbers 1 to 12 around the outer edge and 13 to 24 on an inner circle. The ante meridiem (a.m.) time is read using the numbers 1 to 12, and the post meridiem (p.m.) time is read using the numbers 13 to 24.

- The day starts at midnight, denoted **00:00**.
- The day ends at midnight, denoted **24:00**.
- 30 minutes past the start of the day is denoted **00:30**.

**Conversions:**
- 10.30 a.m. is expressed as 10:30
- 12 noon is expressed as 12:00
- 1.00 p.m. is expressed as 13:00
- 6.00 p.m. is expressed as 18:00

### International standard form

Hours : Minutes : Seconds, written as hh : mm : ss.

In this form, the hours, minutes and seconds are each expressed using two digits. When the number of seconds is not required, the time is expressed using only hours and minutes.

**Example:** 3 minutes and 48 seconds past 1 in the afternoon, written in international standard form, is 13:03:48.

| 12-hour clock | Standard form |
|---|---|
| 1.00 a.m. | 01:00 |
| 9.00 a.m. | 09:00 |
| 12.00 noon | 12:00 |
| 2.00 p.m. | 14:00 |
| 6.00 p.m. | 18:00 |
| 11.00 p.m. | 23:00 |
| 12.00 midnight | 24:00 |

**Example:** Write 2.35 p.m. in international standard form. The answer is 14:35.', 1),
    (uid, '4.3 Representing the Date in Standard Form', 'Writing calendar dates in international standard form, year-month-day.', '## Representing the Date in Standard Form

When writing the date in standard form:
- The **year** is written first, then the **month**, and finally the **day**.
- Four digits are used to represent the year, two digits to represent the month, and two digits to represent the day.

**Example:** The 8th of April, 2015 is represented in international standard form as **2015-04-08**.

**Example:** The day 2015-05-08 ends at 12 midnight. This is represented as 2015-05-08 24:00, which can also be written as 2015-05-09 00:00.', 2),
    (uid, '4.4 Relationships Between Units of Measuring Time', 'Converting between seconds, minutes, hours and days by multiplying or dividing by 60 or 24.', '## Relationships Between Units of Measuring Time

Seconds, minutes, hours and days are units used to measure time.

**Minutes to seconds:** multiply the number of minutes by 60, since 1 minute = 60 seconds.
Example: 8 minutes = 60 x 8 = 480 seconds.

**Seconds to minutes:** divide the number of seconds by 60, since 60 seconds = 1 minute.
Example: 360 seconds = 360 ÷ 60 = 6 minutes.
Example: 150 seconds = 120 seconds + 30 seconds = 2 minutes and 30 seconds.

**Hours to minutes:** multiply the number of hours by 60, since 1 hour = 60 minutes.
Example: 8 hours = 60 x 8 = 480 minutes.

**Minutes to hours:** divide the number of minutes by 60, since 60 minutes = 1 hour.
Example: 720 minutes = 720 ÷ 60 = 12 hours.
Example: 200 minutes = 180 minutes + 20 minutes = 3 hours and 20 minutes.

**Days to hours:** multiply the number of days by 24, since 1 day = 24 hours.
Example: 4 days = 24 x 4 = 96 hours.

**Hours to days:** divide the number of hours by 24, since 24 hours = 1 day.
Example: 144 hours = 144 ÷ 24 = 6 days.
Example: 37 hours = 24 hours + 13 hours = 1 day and 13 hours.

**Summary of relationships:**
- 60 seconds = 1 minute
- 60 minutes = 1 hour
- 24 hours = 1 day', 3),
    (uid, '4.5 Elapsed Time', 'Finding how much time has passed between a start time and an end time.', '## Elapsed Time

To find the elapsed time of a task or event, find the difference between the time it started and the time it ended.

**Example:** Sumith''s mother left home at 2.00 p.m. and returned at 3.30 p.m.
- Method 1: the period between 2.00 p.m. and 3.00 p.m. is 1 hour; the period between 3.00 p.m. and 3.30 p.m. is 30 minutes. Elapsed time = 1 hour and 30 minutes.
- Method 2: subtract directly. 3 hours 30 minutes minus 2 hours 00 minutes = 1 hour and 30 minutes.

**Example:** Samith''s sister studied from 7.30 p.m. to 10.15 p.m. Since both times are in p.m., the times can be subtracted directly in hours and minutes: 10 hours 15 minutes minus 7 hours 30 minutes. Since 30 minutes cannot be subtracted from 15 minutes, 1 hour (60 minutes) is borrowed from the hours column, making 75 minutes. 75 - 30 = 45 minutes, and 9 - 7 = 2 hours. Elapsed time = 2 hours 45 minutes.

**Example:** A school prize giving started at 9.30 a.m. and ended at 1.45 p.m. Since the start is a.m. and the end is p.m., both times are first written using the 24-hour clock: starting time = 09:30, ending time = 13:45. Duration = 13:45 - 09:30 = 4 hours 15 minutes.

When an event''s start and end fall in different periods (a.m./p.m.) of the same day, it is easiest to solve elapsed-time problems by first writing both times according to the 24-hour clock.', 4),
    (uid, '4.6 Addition of Time', 'Adding two durations of time, carrying over between seconds, minutes, hours and days.', '## Addition of Time

Durations of time (hours and minutes, minutes and seconds, days and hours) are added by adding each unit column separately, carrying over when a column reaches 60 (or 24 for days and hours), just as with whole numbers.

**Example:** A bus takes 1 hour 30 minutes to travel from Matara to Galle, and 3 hours 20 minutes to travel from Galle to Colombo. Total time from Matara to Colombo:

```
 Hours  Minutes
   1      30
 + 3      20
   4      50
```
Total = 4 hours 50 minutes.

**Example:** Add 3 hours 50 minutes and 4 hours 40 minutes.
- Minutes: 50 + 40 = 90 minutes = 1 hour 30 minutes. Write 30 in the minutes column, carry 1 hour.
- Hours: 1 (carried) + 3 + 4 = 8.
- Total = 8 hours 30 minutes.

**Example:** Add 3 minutes 45 seconds and 5 minutes 30 seconds.
- Seconds: 45 + 30 = 75 seconds = 1 minute 15 seconds. Write 15 seconds, carry 1 minute.
- Minutes: 1 + 3 + 5 = 9.
- Total = 9 minutes 15 seconds.

**Example:** Add 2 days 20 hours and 3 days 15 hours.
- Hours: 20 + 15 = 35 hours = 1 day 11 hours. Write 11 hours, carry 1 day.
- Days: 1 + 2 + 3 = 6.
- Total = 6 days 11 hours.', 5),
    (uid, '4.7 Subtraction of Time', 'Subtracting one duration of time from another, borrowing between seconds, minutes, hours and days.', '## Subtraction of Time

To subtract time durations, each unit column is subtracted separately, borrowing from the next larger unit when needed, 60 seconds from a minute, 60 minutes from an hour, or 24 hours from a day.

**Example:** 4 minutes 30 seconds minus 2 minutes 15 seconds = 2 minutes 15 seconds (subtracting seconds and minutes separately, with no borrowing needed).

**Example:** 5 hours 35 minutes minus 2 hours 25 minutes = 3 hours 10 minutes.

**Example:** Subtract 1 minute 40 seconds from 3 minutes 15 seconds.
- 40 seconds cannot be subtracted from 15 seconds, so 1 minute (60 seconds) is borrowed from the 3 minutes, making 75 seconds. 75 - 40 = 35 seconds.
- With 1 minute borrowed, 2 minutes remain; 2 - 1 = 1 minute.
- Answer: 1 minute and 35 seconds.

**Example:** Subtract 1 hour 45 minutes from 4 hours 15 minutes.
- 45 minutes cannot be subtracted from 15 minutes, so 1 hour (60 minutes) is borrowed from the 4 hours, making 75 minutes. 75 - 45 = 30 minutes.
- With 1 hour borrowed, 3 hours remain; 3 - 1 = 2 hours.
- Answer: 2 hours and 30 minutes.', 6);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '1 minute = 60 seconds, 1 hour = 60 minutes, and 1 day = 24 hours', 0),
    (uid, 'The 24-hour international standard form hh:mm:ss writes every value with two digits, e.g. 2.35 p.m. is 14:35', 1),
    (uid, 'Dates in standard form go year-month-day with four digits for the year, e.g. 2015-04-08 for the 8th of April 2015', 2),
    (uid, 'Elapsed time is found by subtracting the start time from the end time, converting both to 24-hour form first if one is a.m. and the other p.m.', 3);
end $$;

-- Seeds Grade 6 units/concepts/short notes for three more chapters from the
-- official Educational Publications Department Grade 6 Mathematics textbook
-- (Part I, English medium, ISBN 978-955-25-0076-3): Number Line, Estimation
-- and Rounding off, and Directions. Run after supabase_content_schema.sql
-- and supabase_seed_grade6.sql.

-- 1. Number Line
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Number Line', null, '#06B6D4', 'int', 'Learn to draw and read a number line, understand negative numbers and integers, and use the number line to represent and compare integers.', 3)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Marking whole numbers on a number line', 'Drawing a number line and marking whole numbers on it with equal gaps', '## Marking whole numbers on a number line

A ruler is marked with the whole numbers 0, 1, 2, 3, ... with equal gaps between them, starting from 0 and gradually increasing in value. The same kind of calibration is used in a spring balance (for weighing) and a measuring cylinder (for measuring liquids).

**Drawing a number line:**
1. Draw a straight line using a ruler.
2. Mark several points on the line, leaving equal gaps between the points.
3. Name the points 0, 1, 2, 3, ... starting from the leftmost point and gradually increasing in value towards the right.
4. Draw an arrowhead at the right end of the line.

**Key facts:**
- A line such as this, used to represent numbers, is called a **number line**.
- An arrowhead is drawn at the right end of the number line.
- The values of the numbers on a number line increase gradually towards the right.
- Two whole numbers next to each other on the number line, where the difference between them is 1, are called **consecutive whole numbers**.
- Quantitative information about things can be represented on a number line, by marking a number as a dot at the point corresponding to its value.

**Example:** A grade 6 student''s eraser, pencil and pen are 4 cm, 10 cm and 14 cm long respectively. Marking these three values on a number line from 0 to 15 shows that:
- The pen is longer than the pencil.
- The eraser is shorter than the pen.
- The pencil is 6 units longer than the eraser.

**Worked example:** A number line marked in equal gaps from 0 to 24 (with 0, 8, 16 and 24 labelled) is used to show temperatures in degrees Celsius in four cities. City A is 12°C, city B is 8°C, city C is 4°C and city D is 10°C. Each of these values is marked as a dot at its corresponding point on the number line.', 0),
    (uid, 'Negative numbers', 'Extending the number line to the left of zero to show negative numbers and integers', '## Negative numbers

The number line can be extended towards the left of 0, marking points to the left leaving the same equal gaps as on the right.

- The point that is one gap to the left of 0 is called **negative one**, written **−1**. The sign ''−'' is called the **negative sign**. The distance from 0 to 1 is the same as the distance from 0 to −1.
- Continuing in the same manner, the points further to the left are −2, −3, −4, −5, and so on.

**Note:**
- An arrowhead is still drawn at the right end of a number line that includes negative numbers.
- Sometimes arrowheads are drawn at both ends of a number line with positive and negative numbers.
- Sometimes no arrowheads are used at either end.

**Definitions:**
- The whole numbers to the right of zero are called **positive integers**: 1, 2, 3, 4, ... and so on.
- The numbers to the left of zero are **negative numbers**. The negative whole numbers to the left of zero are called **negative integers**: −1, −2, −3, ... and so on.
- **Zero is neither positive nor negative.**
- The positive integers, the negative integers and zero, all taken together, are called the **integers**: ..., −3, −2, −1, 0, 1, 2, 3, ...

**Real-world use:** In many parts of the world the temperature drops below zero degrees Celsius. A standard temperature of 0°C is taken, and temperatures below it are written with a negative sign in front of the number (for example, −2°C, −5°C, −10°C). Thermometers use the same idea.

| City | Maximum value | Minimum value |
|---|---|---|
| New York | 15°C | −2°C |
| Paris | 18°C | −5°C |
| Tokyo | 0°C | −12°C |
| Moscow | −2°C | −10°C |
| Peking | 2°C | −8°C |

**Example:** On a certain day, the minimum temperatures recorded were: Moscow −12°C, Tokyo 3°C, Peking −4°C and London −3°C. These four values can be represented as dots on a suitable number line running from −12 to 3.', 1),
    (uid, 'Comparison of integers', 'Using the inequality signs > and < to compare two integers, including negative integers', '## Comparison of integers

We know that five is greater than two, written concisely using a symbol as **5 > 2**. Here the symbol **">"**, which means "greater than", is placed between the two numbers.

Similarly, the fact that two is less than five is written **2 < 5**. The symbol **"<"** means "less than".

- Larger integer **>** Smaller integer
- Smaller integer **<** Larger integer

The symbols ">" and "<" are called **inequality signs**. The pointed side of each symbol always faces the smaller number.

**Using the number line to compare:** Any number to the right of a particular number on the number line is greater (larger) than that number. This rule applies along the whole number line, so it can be used to compare integers too, including negative integers.

**Worked examples:**
- On a number line, 0 is to the right of −2. Therefore 0 is greater than −2, written **0 > −2**.
- On a number line, −1 is to the right of −5. Therefore −1 is greater than −5, written **−1 > −5**.
- **Example 1:** Compare −4 and 1. On the number line, 1 is to the right of −4, so this can be expressed as 1 > −4, or equally as −4 < 1.
- **Example 2:** Fill in the blanks using a suitable number from 6, 11 and 13: 11 < ...... (13), 11 > ...... (6), 11 = ...... (11).', 2),
    (uid, 'Comparison of integers described further', 'Comparing several integers at once and writing them in ascending or descending order', '## Comparison of integers described further

The number line can easily be used to compare more than two numbers together.

**Worked example:** Take the integers 3, 0, −1 and −3, and mark them on a number line. On a number line, the values of numbers increase gradually from left to right. Writing these numbers in the order in which their values increase, from left to right, gives:

**−3, −1, 0, 3**

When numbers are written in increasing order of their values like this, we say the numbers are written in **ascending order**.

The same four numbers can also be written as 3, 0, −1, −3, with the values gradually decreasing. When numbers are written in this way, in decreasing order of their values, we say the numbers are written in **descending order**.', 3),
    (uid, 'Finding integers between two non-consecutive integers', 'Using a number line to list all the integers that lie between two given integers', '## Finding integers between two non-consecutive integers

**Worked example:** Sitha is 10 years old and her brother Madhava is 6 years old. Sriya, who lives nearby, has an age in years that is between 6 and 10. The integers between 6 and 10 are only 7, 8 and 9. Therefore Sriya''s age can be 7, 8 or 9. This can easily be confirmed by marking 6 and 10 on a number line and reading off the integers that lie strictly between them.

In this way, the integers lying between any two non-consecutive integers can be found using a number line.

| Pair of integers | All the integers that lie between them |
|---|---|
| −4 and 1 | −3, −2, −1, 0 |
| 0 and −5 | −1, −2, −3, −4 |
| −1 and −5 | −2, −3, −4 |
| −3 and 3 | −2, −1, 0, 1, 2 |', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A number line has equal gaps between numbers, with values increasing towards the right, and usually an arrowhead at the right end', 0),
    (uid, 'Numbers to the left of zero are negative integers, numbers to the right of zero are positive integers, and zero itself is neither positive nor negative', 1),
    (uid, 'Integers are ..., −3, −2, −1, 0, 1, 2, 3, ... — the positive integers, the negative integers, and zero, all together', 2),
    (uid, 'On a number line, a number to the right is always greater than a number to the left — ">" means greater than and "<" means less than', 3);
end $$;

-- 2. Estimation and Rounding off
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Estimation and Rounding off', null, '#F59E0B', 'hash', 'Learn how to make a good estimate of the number of items in a collection without counting them all, and how to round off whole numbers to the nearest multiple of ten.', 4)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Estimation', 'Finding a close value for the number of items in a collection without counting them all', '## Estimation

To know the exact number of items in a collection, it is necessary to count them, but this is not always possible. However, a person with experience can make a good guess and come up with a close value.

**Estimation** is finding a close value for the number of items in a collection, without counting the items, but using a suitable method instead.

The method most often used is to find a value close to the total by considering the number of items in a portion of the collection. In this method, the portion considered is taken as a **unit**, and the total number of items is estimated by comparing the rest of the collection to that unit.

**Example 1:** Two stacks of copies of a newspaper are shown, stack A and stack B. There are 10 newspapers in stack B. By comparing the heights of the two stacks using a divided measuring line, the height of stack A is found to be roughly four times the height of stack B.
- Number of newspapers in stack B = 10
- Number of newspapers in stack A is approximately = 10 × 4 = **40**

**Example 2:** A glass container P is filled with marbles for sale. Container Q shows the same container after 16 marbles were sold. The space that was initially occupied by the marbles is about seven times the space that has been emptied by the sale of the marbles.
- Number of marbles sold = 16
- Number of marbles there were initially in container P is approximately = 16 × 7 = **112**', 0),
    (uid, 'Rounding off', 'Expressing a whole number as the closest multiple of ten', '## Rounding off

There are many instances in day to day life where the multiple of ten closest to a given number is used as an approximate value of that number, in order to get an idea about the number easily.

**Example:** 38 students are to participate in a field trip. The teacher informs the Principal that the number of students participating is about 40 — since 40 is the multiple of ten closest to 38.

Expressing a whole number as the multiple of ten that is closest to it is called **rounding off to the nearest multiple of ten**.

**Rule for rounding off:** Look at the digit in the ones place of the number.
- If it is **less than 5**, the closest multiple of ten that is *less than* the number is selected (round down).
- If it is **5 or greater than 5**, the closest multiple of ten that is *greater than* the number is selected (round up).

**Example 1:** Round off the following numbers to the nearest multiple of ten:
- 78 → 80
- 36 → 40
- 53 → 50
- 85 → 90

**Example 2:** From the numbers 45, 44, 37, 48, 35 — the numbers that round off to 40 are **44, 37 and 35**.

**Example 3:** Iresha''s marks for Science, when rounded off to the nearest multiple of ten, gave 70. Niromi, who scored 67 marks, scored more than Iresha. Since Iresha''s marks must be less than 67, and must round off to 70, the values that Iresha''s marks could take are **65 or 66** only.', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Estimation means finding a close value for a quantity without counting every item, often by comparing to a known unit or portion', 0),
    (uid, 'To round a whole number to the nearest multiple of ten, look at the digit in the ones place', 1),
    (uid, 'If the ones digit is less than 5, round down to the smaller multiple of ten; if it is 5 or more, round up to the next multiple of ten', 2),
    (uid, '38 rounds off to 40, and 53 rounds off to 50 — rounding gives a quick, approximate idea of a number', 3);
end $$;

-- 3. Directions
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Directions', null, '#22C55E', 'geo', 'Learn the eight main and sub directions and how to describe where one place lies relative to another, plus what it means for a line or surface to be horizontal or vertical.', 5)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'The main directions', 'The four main directions — North, East, South and West — and how a compass shows them', '## The main directions

Knowledge of directions is needed for many everyday activities — weather notifications, customs, and news items often mention directions.

**Recalling the four main directions:** East is the direction in which the sun rises. If you stand with your arms stretched out, facing East, then:
- your right hand points to **South**,
- your left hand points to **North**,
- the direction behind you is **West**.

**Convention for drawing directions:** In a book, directions are usually drawn as a cross, with North at the top, East to the right, South at the bottom, and West to the left. On maps and house plans, North is shown using the notation "N" with an upward arrow.

**Using a compass:** A compass can be used to accurately find the directions from a given position. When a compass is placed on a flat surface, its red needle points in the direction of North. When the compass is rotated so that the letter N is aligned with the point of the red needle, the remaining directions are also correctly indicated by the compass.

**Worked example:** A figure shows a tree, a house, a well and a gate around a child, with North marked. According to the figure:
1. The tree is to the north of the child.
2. The well is to the east of the child.
3. The house is to the west of the child.
4. The gate is to the south of the child.
5. The child is facing South.
6. The child and the tree are both to the north of the gate.', 0),
    (uid, 'Sub directions', 'The four sub directions that lie between the main directions, making eight directions in total', '## Sub directions

Apart from the four main directions, there are four other **sub directions**, each of which divides the right angle between two main directions exactly into two equal halves:

- **North-east**: divides the right angle between North and East.
- **South-east**: divides the right angle between East and South.
- **South-west**: divides the right angle between South and West.
- **North-west**: divides the right angle between West and North.

**The eight directions** are: North, East, South, West, North-east, South-east, South-west and North-west.

**Worked example (using a map of Sri Lanka):** Trincomalee is to the north-east of Dambulla, and Dambulla is to the south-west of Trincomalee. Dondra Head is to the south of Dambulla, and Dambulla is to the north of Dondra Head.

This shows an important idea: **although the location of a place is fixed, the direction in which it lies depends on the place from which it is observed.**', 1),
    (uid, 'The horizontal and the vertical', 'Understanding horizontal and vertical lines, planes and surfaces, and the tools used to check them', '## The horizontal and the vertical

Apart from directions, two other concepts are needed to describe the location of an object: the **horizontal** and the **vertical**.

**Horizontal:**
- The surface of the water in a large basin is considered to be horizontal when the water is still.
- A flat surface that is not inclined is said to be in a **horizontal plane**.
- Any straight line that lies on a horizontal plane is called a **horizontal line**.
- Any two points that lie on a horizontal plane are said to be at the **same level**.

**Vertical:**
- Take a string with a small weight tied to one end, and hold it by the other end. Once the string stops moving, the line along which the string lies is a **vertical line**. (This tool is called a **plumb**.)
- If a plane contains a vertical line, then it is a **vertical plane**.
- Any straight line on a horizontal plane is horizontal, but a straight line on a vertical plane is not necessarily vertical.
- When two points lie on the same vertical line, one point is said to lie **vertically above** the other.

**Everyday examples:** A table''s flat top surface is horizontal, while the edge of a table leg is vertical. In a room, the wall and the door are vertical, while the floor and the ceiling are horizontal. A cupboard has both horizontal and vertical surfaces and edges.

**Tools used to check horizontal and vertical:**
- A **spirit level** is used to determine whether a plane surface is horizontal — when the air bubble sits at the centre, the surface is horizontal.
- A **plumb** (a weighted string) is used to identify vertical positions, such as checking that a door frame is vertical.
- A transparent tube of water can be used to check whether two points are at the same level (horizontal to each other).', 2);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'The eight directions are North, East, South, West, North-east, South-east, South-west and North-west', 0),
    (uid, 'Each sub direction (North-east, South-east, South-west, North-west) divides the right angle between two main directions exactly in half', 1),
    (uid, 'Although a place''s location is fixed, the direction in which it lies depends on where you are observing it from', 2),
    (uid, 'A flat, still water surface is horizontal; a plumb line shows the vertical direction; a spirit level checks whether a surface is horizontal', 3);
end $$;

-- Seeds Grade 6 units/concepts/short notes for batch 3:
--   Fractions, Selection, Factors and Multiples
-- Source: Educational Publications Department, Grade 6 Mathematics
-- Pupils' Book, Part I (ISBN 978-955-25-0076-3), pages 112-155.
-- Run after supabase_content_schema.sql (and any earlier seed files).

do $$
declare uid bigint;
begin
  -- 9. Fractions
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Fractions', null, '#00D9C0', 'frac', 'Identify proper fractions, unit fractions and equivalent fractions, compare fractions, and add and subtract proper fractions.', 6)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Introduction', 'How dividing a whole into equal parts gives us fractions such as halves and thirds.', '## Introduction

When a whole unit (a guava, a cake, a shape) is divided into equal parts, each part can be written as a **fraction** of the whole.

- A guava divided into **2 equal parts**: one part is **1/2** of the guava, read as "one half".
- A cake divided into **3 equal parts**: one part is **1/3** of the cake, read as "one third".

In general, if we represent the whole unit numerically as **1**, and divide it into equal parts, then the quantity represented by one or more of those parts can be written as a fraction:

- Divided into 2 equal parts, 1 part coloured -> 1/2 ("one half")
- Divided into 3 equal parts, 1 part coloured -> 1/3 ("one third")
- Divided into 4 equal parts, 1 part coloured -> 1/4 ("one fourth")
- Divided into 3 equal parts, 2 parts coloured -> 2/3 ("two thirds")

**Note:** In general use, we read 1/2 as **half**, 1/4 as **quarter**, and 3/4 as **three quarters**.

Looking at shapes divided into equal parts and shaded differently, the same fraction (for example 2/6, 3/8 or 5/9) can be shown by shading different parts of the shape, as long as the same number of equal parts is shaded.

The numbers which are less than one and greater than zero, represented in this way, are known as **proper fractions**. Examples of proper fractions are 1/2, 1/4, 2/3 and 3/8.

**Note:** There are fractions greater than one as well (studied in a higher grade). Also, when a shape is divided into unequal parts, a shaded part is not correctly described by a simple fraction such as 1/4 — the parts must be equal for the fraction to apply.', 0),
    (uid, 'The Denominator and the Numerator of a Fraction', 'Learn the names of the top and bottom numbers of a fraction, and what unit fractions are.', '## The Denominator and the Numerator of a Fraction

Consider the fraction 4/7.

- **7** is the number of equal parts the whole unit is divided into. This is called the **denominator**, written below the line.
- **4** is the number of parts considered. This is called the **numerator**, written above the line.

```
4  <- numerator
-
7  <- denominator
```

- The number written below the line is the **denominator** of the fraction.
- The number written above the line is the **numerator** of the fraction.

In a proper fraction, the numerator is always less than the denominator.

Fractions such as 1/2, 1/3, 1/4 and 1/5, where the numerator is one, are called **unit fractions**. A unit fraction shows the quantity of just one part when a whole unit is divided into equal parts. Unit fractions are important because other fractions can be explained using them.

**Example:** 2/3 can be explained in terms of 1/3. If a unit is divided into three equal parts, one part is 1/3 of the whole. The coloured quantity 2/3 is made up of two such parts — so 2/3 is **two 1/3s**.

Similarly:
- 3/4 is three 1/4s
- 5/7 is five 1/7s
- three 1/5s make up 3/5', 1),
    (uid, 'Equivalent Fractions', 'Different-looking fractions, like 1/2 and 2/4, that represent exactly the same amount.', '## Equivalent Fractions

Two circular cards of the same size are folded differently: the first is folded once (giving 2 equal parts), the second is folded twice (giving 4 equal parts). When half of each card is coloured:

- The coloured portion of the first card is 1/2 of the entire card.
- The coloured portion of the second card is 2/4 of the entire card.

Since the coloured quantity is the same on both cards, the numbers 1/2 and 2/4 represent the same value:

**1/2 = 2/4**

Fractions which represent the same value, although they have different numerators and denominators, are known as **equivalent fractions**. Accordingly, 1/2 and 2/4 are equivalent fractions. In the same way, 1/2, 2/4, 3/6, 4/8 and 5/10 are all equivalent fractions, since the same portion of a whole is shaded in each case.

**Method 1 — multiply:** By multiplying both the numerator and the denominator of a fraction by the same whole number (except zero), an equivalent fraction is obtained.

| Original | Multiply by | Result |
|---|---|---|
| 1/2 | x2 / x2 | 2/4 |
| 1/2 | x3 / x3 | 3/6 |
| 1/2 | x4 / x4 | 4/8 |
| 1/2 | x5 / x5 | 5/10 |

**Method 2 — divide:** By dividing both the numerator and the denominator of a fraction by the same whole number (where the division leaves no remainder), an equivalent fraction is obtained.

| Original | Divide by | Result |
|---|---|---|
| 2/4 | /2 / /2 | 1/2 |
| 3/6 | /3 / /3 | 1/2 |
| 4/8 | /4 / /4 | 1/2 |

**Example 1:** Write down two fractions equivalent to 2/10.
2/10 = (2x3)/(10x3) = 6/30, and 2/10 = (2/2)/(10/2) = 1/5.
So 6/30 and 1/5 are both equivalent to 2/10.

**Example 2:** Determine whether 2/10 and 3/15 are equivalent fractions.
2/10 = (2/2)/(10/2) = 1/5, and 3/15 = (3/3)/(15/3) = 1/5.
Since both simplify to 1/5, 2/10 and 3/15 are equivalent fractions.', 2),
    (uid, 'Comparison of Fractions', 'Rules for telling which of two fractions is bigger, whether they share a numerator, a denominator, or neither.', '## Comparison of Fractions

**Comparing unit fractions (numerator = 1):** Out of two unit fractions, the larger fraction is the one with the **smaller denominator**. For example, 1/3 is greater than 1/5, written 1/3 > 1/5.

**Comparing fractions with the same numerator:** Out of two fractions with the same numerator, the larger fraction is again the one with the **smaller denominator**. For example, since 2/3 is two 1/3s and 2/5 is two 1/5s, and 1/3 > 1/5, it follows that 2/3 > 2/5.

**Comparing fractions with the same denominator:** Out of two fractions with the same denominator, the larger fraction is the one with the **larger numerator**. For example:

1/6 < 2/6 < 3/6 < 4/6 < 5/6 < 1

**Example 1:** Arrange 4/5, 1/5, 2/5 in ascending order.
Since 1/5 < 2/5 < 4/5, the ascending order is 1/5, 2/5, 4/5.

**Comparing fractions with different numerators and denominators:** First rewrite the fractions as equivalent fractions with the same denominator, then compare numerators.

**Example 2:** Compare 1/6 and 5/12.
1/6 = 2/12. Since 5/12 > 2/12, we get 5/12 > 1/6.

**Example 3:** Select the larger fraction out of 1/2 and 3/4.
1/2 = 2/4. Since 3/4 > 2/4, we have 3/4 > 1/2. Therefore the larger fraction is 3/4.', 3),
    (uid, 'Addition and Subtraction of Fractions', 'How to add and subtract fractions, both when the denominators match and when they do not.', '## Addition and Subtraction of Fractions

**Same denominator — addition:** A cake is divided into 8 equal parts, so one part is 1/8 of the cake. If Damith eats 2/8 and his sister eats 1/8, together they eat three 1/8s, that is 3/8.

2/8 + 1/8 = 3/8

**Rule:** When adding fractions with the same denominator, keep the denominator, and add the numerators.

**Example 1:** 2/4 + 1/4 = (2+1)/4 = 3/4
**Example 2:** 2/9 + 5/9 = (2+5)/9 = 7/9

**Same denominator — subtraction:** Lakindu had 3/5 of a chocolate bar (divided into 5 equal parts). He gave 1/5 to Sakindu, leaving him with 2/5.

3/5 - 1/5 = 2/5

**Rule:** When subtracting fractions with the same denominator, keep the denominator, and subtract the numerators.

**Example 1:** 5/7 - 2/7 = (5-2)/7 = 3/7
**Example 2:** 10/13 - 4/13 = (10-4)/13 = 6/13
**Example 3:** 7/15 - 2/15 = 5/15, which simplifies (divide both by 5) to 1/3.

**Different denominators — addition:** First convert the fractions to equivalent fractions with the same denominator, then add.

**Example:** Add 3/10 and 2/5. Since 2/5 = 4/10, we get 3/10 + 4/10 = 7/10.
**Example:** 1/2 + 1/4 = 2/4 + 1/4 = 3/4.
**Example:** 2/3 + 1/15 = 10/15 + 1/15 = 11/15.

**Different denominators — subtraction:** Again, first find equivalent fractions with a common denominator.

**Example:** 1/2 - 1/4 = 2/4 - 1/4 = 1/4.
**Example:** 7/10 - 2/5 = 7/10 - 4/10 = 3/10.
**Example:** 2/3 - 3/12 = 8/12 - 3/12 = 5/12.', 4),
    (uid, 'A Fraction of a Homogeneous Collection', 'Using a fraction to describe part of a group of separate items, not just a slice of one whole shape.', '## A Fraction of a Homogeneous Collection

So far, fractions have described parts of a single whole unit divided into equal pieces. A fraction can also describe part of a **collection** of separate items.

- Take a collection of **4 balls** as the unit. Remove one ball. The balls remaining, 3 out of 4, are 3/4 of the collection.
- From a collection of **5 flowers**, if 2 of them are purple, the purple flowers are 2/5 of the collection.
- From a collection of **7 buttons**, if 4 of them are brown, the brown buttons are 4/7 of the collection.

In each case, the fraction is formed the same way as before: the denominator is the total number of items in the collection, and the numerator is the number of items being described.', 5);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A proper fraction has a numerator smaller than its denominator, and its value lies between 0 and 1', 0),
    (uid, 'A unit fraction has a numerator of 1, such as 1/2, 1/3, 1/4 or 1/5', 1),
    (uid, 'Multiplying or dividing both the numerator and denominator by the same non-zero whole number gives an equivalent fraction', 2),
    (uid, 'To add or subtract fractions with different denominators, first rewrite them as equivalent fractions with the same denominator', 3);

end $$;

do $$
declare uid bigint;
begin
  -- 10. Selection
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Selection', null, '#A855F7', 'pat', 'Sort a collection of items into groups based on a shared characteristic, and give each group a suitable descriptive name.', 7)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Grouping by a Common Characteristic', 'Splitting a mixed collection into groups whose members share a feature.', '## Grouping by a Common Characteristic

Most collections of things can be separated into groups based on a common characteristic that all members of a group share.

**Example:** Consider a collection of animals: dog, cock, lion, parrot, tiger, mynah, deer, crow, horse. This collection can be grouped in more than one way.

- **Group 1** — dog, lion, deer, tiger, horse: a common characteristic is that they each have **four feet**. This group can be named "Four-footed animals in this collection".
- **Group 2** — parrot, cock, mynah, crow: a common characteristic is that they can all **fly**, so this group can be named "Birds in this collection". Another common characteristic is that they each have only **two feet**, so the group could also be named "Two-footed animals in this collection".

The same collection of animals could also be separated into three groups — Herbivores, Carnivores and Omnivores — based on what they eat, showing that a collection can be grouped in different ways depending on which characteristic is chosen.

**Grouping numbers:** Consider the numbers 2, 5, 3, 8, 11, 4, 7, 9 and 6. These can be separated into two groups:

- **2, 4, 6, 8** — the common characteristic is that these numbers can be divided by two with no remainder. Proposed name: **Even numbers** in this collection.
- **3, 5, 7, 9, 11** — the common characteristic is that these numbers leave a remainder of 1 when divided by two. Proposed name: **Odd numbers** in this collection.', 0),
    (uid, 'Naming Groups and Multiple Ways of Grouping', 'The same collection can be sorted in different ways depending on which shared feature you pick.', '## Naming Groups and Multiple Ways of Grouping

A single collection often contains more than one possible common characteristic, so it can be separated into groups in several different valid ways — for example, a collection of vegetables and fruits can be split into "vegetables" and "fruits"; a mixed collection of letters and digits can be split by that distinction; a collection of vehicles can be split by whether they travel on land, sea or air; and a collection of numbers could be grouped by whether they are multiples of a given number, or whether they are fractions with a particular denominator.

After separating a collection into groups:

- Identify what characteristic the members of each group have in common.
- Give each group a **suitable name** that describes that shared characteristic.
- The same collection can be regrouped differently if a different characteristic is used instead.', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A collection of items can be separated into groups based on a shared, common characteristic', 0),
    (uid, 'The same collection can often be grouped in more than one way, depending on which characteristic is chosen', 1),
    (uid, 'Even numbers divide by 2 with no remainder; odd numbers leave a remainder of 1 when divided by 2', 2),
    (uid, 'Once a group is formed, give it a name that describes what its members have in common', 3);

end $$;

do $$
declare uid bigint;
begin
  -- 11. Factors and Multiples
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Factors and Multiples', null, '#EC4899', 'hash', 'Find the factors and multiples of a whole number, use them to solve problems, and test whether a number is divisible by 2, 5 or 10.', 8)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Identifying Factors', 'Any whole number can be written as a product of two whole numbers in several ways — those numbers are its factors.', '## Identifying Factors

Consider 6 chairs arranged in equal rows in different ways:

- 1 row of 6 chairs -> 6 = 1 x 6
- 2 rows of 3 chairs -> 6 = 2 x 3
- 3 rows of 2 chairs -> 6 = 3 x 2
- 6 rows of 1 chair -> 6 = 6 x 1

In each arrangement, the total (6) is the product of the number of chairs in a row and the number of rows — showing that 6 can be written as a product of two whole numbers in various ways. The same is true for 12:

12 = 1x12 = 2x6 = 3x4 = 4x3 = 6x2 = 12x1

**When a whole number is written as a product of two whole numbers, those two numbers are known as factors of the original number.**

- Since 6 = 1x6, the numbers 1 and 6 are factors of 6. Since 6 = 2x3, 2 and 3 are also factors of 6. So the factors of 6 are **1, 2, 3, 6**.
- The factors of 12 are **1, 2, 3, 4, 6, 12**.
- 16 = 1x16 = 2x8 = 4x4, so the factors of 16 are **1, 2, 4, 8, 16**.

**Example:** Find the factors of 20.
20 = 1x20 = 2x10 = 4x5
The factors of 20 are 1, 2, 4, 5, 10 and 20.

**Note:** 0 is not a factor of a whole number.', 0),
    (uid, 'Finding Factors Using the Multiplication Table', 'Spotting factors of a number by finding it inside a 10 x 10 multiplication table.', '## Finding Factors Using the Multiplication Table

A 10 x 10 multiplication table can be used to find factors of a whole number, by looking for every place the number appears as a product.

| x | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 2 | 2 | 4 | 6 | 8 | 10 | 12 | 14 | 16 | 18 | 20 |
| 3 | 3 | 6 | 9 | 12 | 15 | 18 | 21 | 24 | 27 | 30 |
| 4 | 4 | 8 | 12 | 16 | 20 | 24 | 28 | 32 | 36 | 40 |
| 5 | 5 | 10 | 15 | 20 | 25 | 30 | 35 | 40 | 45 | 50 |
| 6 | 6 | 12 | 18 | 24 | 30 | 36 | 42 | 48 | 54 | 60 |
| 7 | 7 | 14 | 21 | 28 | 35 | 42 | 49 | 56 | 63 | 70 |
| 8 | 8 | 16 | 24 | 32 | 40 | 48 | 56 | 64 | 72 | 80 |
| 9 | 9 | 18 | 27 | 36 | 45 | 54 | 63 | 72 | 81 | 90 |
| 10 | 10 | 20 | 30 | 40 | 50 | 60 | 70 | 80 | 90 | 100 |

**Finding the factors of 20:** Looking for 20 as a product in the table gives 20 = 2x10 and 20 = 4x5. So the numbers **2, 4, 5 and 10** are four factors of 20 that can be found using the table.

**Example 1:** What are the factors of 72 that can be found using the table?
72 = 8x9, so 8 and 9 are the two factors of 72 that can be found using the table.

**Example 2:** What are the factors of 18 that can be found using the table?
18 = 3x6 and 18 = 2x9, so 2, 3, 6 and 9 are the four factors of 18 that can be found using the table.', 1),
    (uid, 'Finding Factors Using the Method of Division', 'Dividing a number by a candidate factor: no remainder means it is a factor.', '## Finding Factors Using the Method of Division

When a number is divided by one of its factors, there is no remainder. For example, the factors of 6 are 1, 2, 3 and 6:

6 / 1 = 6 remainder 0
6 / 2 = 3 remainder 0
6 / 3 = 2 remainder 0
6 / 6 = 1 remainder 0

But dividing 6 by numbers that are **not** its factors leaves a remainder:

6 / 4 = 1 remainder 2
6 / 5 = 1 remainder 1

**If a whole number can be divided by another whole number such that there is no remainder, the second number is a factor of the first.** Since any whole number can be divided by 1 and by itself with no remainder, 1 and the number itself are always factors of that number.

**Example 1:** Find three factors of 30 by the method of division.
30 / 2 = 15 remainder 0
30 / 3 = 10 remainder 0
30 / 5 = 6 remainder 0
So 2, 3 and 5 are three factors of 30.

**Example 2:** Is 9 a factor of 12?
12 / 9 = 1 remainder 3. Since the remainder is not zero, 9 is **not** a factor of 12.', 2),
    (uid, 'Multiples', 'Numbers obtained by multiplying a whole number, and how they can help solve grouping problems.', '## Multiples

Multiplying 2 by the whole numbers 1, 2, 3, 4 and 5 gives:

2x1=2, 2x2=4, 2x3=6, 2x4=8, 2x5=10

A number obtained by multiplying 2 by a whole number in this way is a **multiple of 2**. In the same way, a number obtained by multiplying 3 by a whole number is a multiple of 3.

- 3, 6, 9, 12, 15 and 18 are several multiples of three.
- 5, 10, 15 and 20 are several multiples of five.
- All multiples of 2 can be divided by 2 with no remainder; all multiples of 3 can be divided by 3 with no remainder — in general, **any multiple of a whole number can be divided by that number with no remainder**.

A number can be a multiple of more than one number. For example, 18 = 3x6, so 18 is a multiple of 3; but 18 = 6x3 as well, so 18 is also a multiple of 6 — 18 is a multiple of both 3 and 6.

**Example 1:** Check whether 14 is a multiple of 2 by dividing 14 by 2.
14 / 2 = 7 remainder 0. Since there is no remainder, 14 is a multiple of 2.

**Example 2:** Check whether 42 is a multiple of 3 by dividing 42 by 3.
42 / 3 = 14 remainder 0. Since there is no remainder, 42 is a multiple of 3.

### Solving problems related to factors and multiples

**Example:** There are 30 apples, separated into bags with an equal number of apples in each bag. The total (30) is the product of the number of apples per bag and the number of bags — so every pair of factors of 30 gives a valid way to pack the apples:

30 = 1x30 = 2x15 = 3x10 = 5x6 = 6x5 = 10x3 = 15x2 = 30x1

This gives eight possible groupings: 30 bags with 1 apple, 15 bags with 2 apples, 10 bags with 3 apples, 6 bags with 5 apples, 5 bags with 6 apples, 3 bags with 10 apples, 2 bags with 15 apples, and 1 bag with all 30 apples.', 3),
    (uid, 'Divisibility', 'Quick tests to check whether a number is divisible by 2, 5 or 10, just by looking at its last digit.', '## Divisibility

A whole number is **divisible** by another whole number if dividing the first by the second leaves no remainder. For example, 27 / 3 leaves no remainder, so 27 is divisible by 3.

**Divisible by 2:** Looking at the numbers 1 to 20 that are divisible by 2 (2, 4, 6, 8, 10, 12, 14, 16, 18, 20), the digit in the ones place is always 0, 2, 4, 6 or 8. Numbers not divisible by 2 (1, 3, 5, 7, 9, ...) have a ones digit of 1, 3, 5, 7 or 9.

**If the digit in the ones place of a number is divisible by 2 (i.e. 0, 2, 4, 6 or 8), then the number is divisible by 2. Otherwise it is not.**

**Divisible by 5:** Multiples of 5 (5, 10, 15, 20, 25, 30, ...) always have a ones digit of 0 or 5.

**If the digit in the ones place of a number is 0 or 5, then the number is divisible by 5.**

**Divisible by 10:** Multiples of 10 (10, 20, 30, 40, ...) always have a ones digit of 0.

**If the digit in the ones place of a number is 0, then the number is divisible by 10.**', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A factor of a number divides into it exactly, leaving no remainder', 0),
    (uid, 'Every whole number has 1 and itself as factors; 0 is never a factor of a whole number', 1),
    (uid, 'A multiple is the result of multiplying a whole number by another whole number, e.g. 6, 12 and 18 are multiples of 6', 2),
    (uid, 'A number is divisible by 2 if its ones digit is even, by 5 if its ones digit is 0 or 5, and by 10 if its ones digit is 0', 3);
end $$;

-- Seeds Grade 6 units/concepts/short notes for three chapters from the
-- official Educational Publications Department textbook "Maths G-6 P-II E"
-- (ISBN 978-955-25-0077-0): Decimals, Types of Numbers and Number Patterns,
-- and Length. Run after supabase_content_schema.sql.

-- ============================================================
-- 13. Decimals
-- ============================================================
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Decimals', null, '#FF7A45', 'dec', 'Learn to recognise decimal numbers, compare them using their place values, and add and subtract decimal numbers with up to two decimal places.', 9)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '13.1 Introduction to decimals', 'How dividing one whole into ten equal parts gives us tenths, written using a decimal point.', '## Introduction to Decimals

When we divide 1 into 10 equal parts, one part equals **1/10**. This is the same fraction idea learnt in the lesson on fractions.

Another way to write 1/10 is **0.1**. We read 0.1 as "zero point one".

In the same way:
- 2/10 = 0.2 (zero point two)
- 3/10 = 0.3
- 4/10 = 0.4
- 5/10 = 0.5
- 6/10 = 0.6
- 7/10 = 0.7
- 8/10 = 0.8
- 9/10 = 0.9

**Place value in decimals**

Each digit in a number occupies a place. In a decimal number, the dot is called the **decimal point**. The place occupied by the digit just before the decimal point is the **ones place**. The place occupied by the digit that comes right after the decimal point is called the **first decimal place**, and its place value is 1/10.

**Example:** In the number 0.5, the digit 0 is in the ones place and the digit 5 is in the first decimal place, with a value of 5/10.

**Example:** Consider 2.5.
- 2.5 = Two ones + Five 1/10s
- 2.5 = 2 + 0.5

On an abacus, the ones place of 2.5 holds beads worth 2 (two ones) and the tenths place holds beads worth 5/10, that is 0.5.', 0),
    (uid, '13.2 More on introduction to decimals', 'Extending decimal place value to hundredths and the second decimal place.', '## More on Decimals

When we divide 1 into 100 equal parts, one part equals **1/100**.

Using decimal places, 1/100 is written as **0.01**, read as "zero point zero one". Likewise, 4/100 is written as 0.04, read as "zero point zero four".

**The second decimal place**

The place occupied by the digit that comes right after the first decimal place is called **the second decimal place**. Its place value is 1/100.

**Example:** Consider 27/100.

27/100 = 20/100 + 7/100 = 2/10 + 7/100 = Two 1/10s + Seven 1/100s = 0.2 + 0.07

Using decimal places, we write 27/100 as **0.27**, read as "zero point two seven".

Likewise, 45/100 = 0.45 and 67/100 = 0.67.

**Reading digit values in a two-decimal-place number**

Consider 19.67.

| Place | Digit | Value |
|---|---|---|
| Tens | 1 | 10 x 1 = 10 |
| Ones | 9 | 1 x 9 = 9 |
| First decimal place | 6 | Six 1/10s = 6/10 = 0.6 |
| Second decimal place | 7 | Seven 1/100s = 7/100 = 0.07 |

The part of the number to the left of the decimal point is called the **whole number part**. For example, in 19.67 the whole number part is 19.

**Worked Example** — Name the position and value of the marked digit:

| Number | Digit | Position | Value represented |
|---|---|---|---|
| 1.3 | 3 | First decimal place | Three 1/10s = 3/10 |
| 1.28 | 8 | Second decimal place | Eight 1/100s = 8/100 |
| 14.65 | 4 | Ones place | 4 ones = 4 |
| 25.39 | 9 | Second decimal place | Nine 1/100s = 9/100 |
| 1991.06 | 0 | First decimal place | Zero 1/10s = 0 |', 1),
    (uid, '13.3 Comparison of decimals', 'Comparing decimal numbers using fractions or by comparing digits place by place.', '## Comparing Decimals

**Comparing using fractions**

Since 1/10 < 2/10, we know 0.1 < 0.2. In the same way:
- 7/10 = 0.7 and 5/10 = 0.5. Since 7/10 > 5/10, we get 0.7 > 0.5.
- 1 = 10/10 and 0.8 = 8/10. Since 10/10 > 8/10, we get 1 > 0.8. So 1 is greater than 0.8.
- 2 is greater than 1.8, comparing the whole quantities directly.

To compare hundredths, express both numbers with a denominator of 100:
- 0.23 = 23/100 and 0.52 = 52/100. Since 23/100 < 52/100, 0.52 is greater than 0.23.
- 0.3 = 3/10 = 30/100, and 0.32 = 32/100. Since 30/100 < 32/100, 0.3 < 0.32.

**Another method — comparing digit by digit**

- First compare the **whole number part** — the number with the greater whole number part is the greater number.
- If the whole number parts are equal, compare the digit in the **first decimal place** — the greater digit there wins.
- If those are equal too, compare the digit in the **second decimal place**.

**Example 1:** Write 4.15, 3.76 and 3.52 in ascending order.

The greatest whole number part is 4 (from 4.15), so 4.15 is the largest of the three. For 3.76 and 3.52 the whole number parts are equal (3), so compare the first decimal digit: 7 > 5, so 3.76 > 3.52.

Ascending order: 3.52, 3.76, 4.15.

**Example 2:** Find the greater number from 8.76 and 8.72.

The whole number parts are equal (8) and the first decimal digits are equal (7), so compare the second decimal digits: 6 > 2. Therefore 8.76 is the greater number.

**Example 3:** Write 0.3, 0.33 and 0.03 in ascending order.

Since 0.3 = 0.30, compare 0.30, 0.33 and 0.03. All whole number parts are 0. The smallest first-decimal digit belongs to 0.03, so it is the smallest. Between 0.30 and 0.33 (same first decimal digit, 3), 0.33 has the greater second decimal digit, so 0.33 > 0.30.

Ascending order: 0.03, 0.30, 0.33.', 2),
    (uid, '13.4 Adding decimal numbers', 'Adding decimal numbers by lining up decimal points and place values.', '## Adding Decimal Numbers

**Adding tenths**

0.2 + 0.3: since 2/10 + 3/10 = 5/10, we get 0.2 + 0.3 = 0.5.

To add decimals, write the numbers so that digits of the same place are aligned in the same column, with the decimal points aligned in one column. Then add the digits in each place separately, carrying over to the next place when a column total is 10 or more — just as when adding whole numbers.

**Worked Example — Add 2.57 and 1.68**

- **Step 1 (hundredths):** 7 + 8 = 15 hundredths, which is one 1/10 and five 1/100s. Write 5 in the hundredths place and carry 1 to the tenths place.
- **Step 2 (tenths):** 1 (carried) + 5 + 6 = 12 tenths, which is 1 one and two 1/10s. Write 2 in the tenths place and carry 1 to the ones place.
- **Step 3 (ones):** 1 (carried) + 2 + 1 = 4. Write 4 in the ones place.

So, 2.57 + 1.68 = **4.25**.

**Worked Example — Add 5.7 and 2.53**

Since 2.53 has two decimal places, write 5.7 as 5.70 so both numbers have the same number of decimal places, then add:

5.70 + 2.53 = **8.23**', 3),
    (uid, '13.5 Subtraction of decimals', 'Subtracting decimal numbers by lining up decimal points and place values.', '## Subtracting Decimal Numbers

Just as with addition, subtraction is done by writing the digits of the ones place in one column, the decimal points in one column, and the digits of each decimal place in their own columns.

**Example:** 0.7 - 0.3 = 0.4

**Worked Example — Find 3.65 - 1.98**

- **Step 1 (hundredths):** 5 is less than 8, so borrow one 1/10 (ten 1/100s) from the tenths place, making fifteen 1/100s. 15 - 8 = 7. Write 7 in the second decimal place.
- **Step 2 (tenths):** After lending one 1/10, five 1/10s remain (6 - 1 = 5); since 5 is less than 9, borrow one whole unit (ten 1/10s) from the ones place, making fifteen 1/10s. 15 - 9 = 6. Write 6 in the first decimal place.
- **Step 3 (ones):** After lending one unit, 2 ones remain. 2 - 1 = 1. Write 1 in the ones place.

So, 3.65 - 1.98 = **1.67**.

**Worked Example — Find 12.7 - 8.53**

Write 12.7 as 12.70 so both numbers have the same number of decimal places, then subtract:

12.70 - 8.53 = **4.17**', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '0.1 means one tenth (1/10); the decimal point separates the whole number part from the decimal part', 0),
    (uid, 'The first decimal place has place value 1/10; the second decimal place has place value 1/100', 1),
    (uid, 'To compare decimals, first compare the whole number parts, then the first decimal place, then the second decimal place', 2),
    (uid, 'To add or subtract decimals, line up the decimal points and work place by place, carrying or borrowing as needed', 3);
end $$;

-- ============================================================
-- 14. Types of Numbers and Number Patterns
-- ============================================================
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Types of Numbers and Number Patterns', null, '#8B5CF6', 'pat', 'Learn to identify odd, even, prime, composite, square and triangular numbers among the whole numbers, and discover the number patterns they form.', 10)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '14.1 Even numbers and odd numbers', 'Telling even numbers from odd numbers, and rules for adding, subtracting and multiplying them.', '## Even Numbers and Odd Numbers

When a whole number is divided by 2:
- If the **remainder is zero**, the number is an **even number**.
- If the **remainder is one**, the number is an **odd number**.

Even numbers starting from zero: 0, 2, 4, 6, 8, 10, 12, ...
Odd numbers starting from one: 1, 3, 5, 7, 9, 11, 13, ...

**Identifying even/odd from the ones digit**

Any whole number can be split into thousands, hundreds, tens and ones (for example, 2157 = 2000 + 100 + 50 + 7). The parts from the tens place upward are always multiples of 10, so they are always divisible by 2. This means whether a whole number is divisible by 2 depends only on its ones digit.

- If the ones digit is 0, 2, 4, 6 or 8, the number is **even**.
- If the ones digit is 1, 3, 5, 7 or 9, the number is **odd**.

**Note — results of operations on even/odd numbers**

| Operation | Result |
|---|---|
| even + even | even |
| odd + odd | even |
| even + odd | odd |
| even - even | even |
| odd - odd | even |
| odd - even | odd |
| even - odd | odd |
| odd x odd | odd |
| whole number x even | even |

**Example 1:** State whether each of 8, 13, 32, 17, 100, 351, 1001 is even or odd.
- 8 / 2 = 4, no remainder -> even
- 13 / 2 = 6 remainder 1 -> odd
- 32 / 2 = 16, no remainder -> even
- 17 / 2 = 8 remainder 1 -> odd
- 100 / 2 = 50, no remainder -> even
- 351 / 2 = 175 remainder 1 -> odd
- 1001 / 2 = 500 remainder 1 -> odd', 0),
    (uid, '14.2 Prime numbers and Composite numbers', 'Finding prime numbers (exactly two factors) and composite numbers (more than two factors).', '## Prime Numbers and Composite Numbers

Recall that a **factor** of a number divides into it exactly.

| Number | As a product | Factors |
|---|---|---|
| 2 | 1 x 2 | 1, 2 |
| 3 | 1 x 3 | 1, 3 |
| 4 | 1 x 4, 2 x 2 | 1, 2, 4 |
| 5 | 1 x 5 | 1, 5 |
| 6 | 1 x 6, 2 x 3 | 1, 2, 3, 6 |
| 7 | 1 x 7 | 1, 7 |
| 8 | 1 x 8, 2 x 4 | 1, 2, 4, 8 |
| 9 | 1 x 9, 3 x 3 | 1, 3, 9 |

Numbers 2, 3, 5 and 7 each have only two distinct factors (1 and themselves). Numbers 4, 6, 8 and 9 each have more than two distinct factors.

**Whole numbers greater than one that have exactly two distinct factors are called prime numbers.**

The prime numbers from 1 to 20 are: 2, 3, 5, 7, 11, 13, 17 and 19.

Of these, only 2 is even — all the other prime numbers are odd. This is because every other even number has more than two factors, so **2 is the only even prime number**.

**Whole numbers greater than one, other than prime numbers, are called composite numbers** — that is, numbers with more than two distinct factors, such as 4, 6, 8 and 9.

**1 is neither a prime number nor a composite number.**', 1),
    (uid, '14.3 Square numbers', 'Numbers that can be arranged as dots in a square shape, like 1, 4, 9 and 16.', '## Square Numbers

Some numbers can be arranged as dots in a square formation, where the number of dots in a row equals the number of dots in a column:

| Dots | Arrangement |
|---|---|
| 1 | 1 row, 1 column |
| 4 | 2 rows, 2 columns |
| 9 | 3 rows, 3 columns |
| 16 | 4 rows, 4 columns |

Multiplying the number of rows by the number of columns gives the number represented:
- 1 = 1 x 1
- 4 = 2 x 2
- 9 = 3 x 3
- 16 = 4 x 4

25, 36 and 49 can also be written this way (5 x 5, 6 x 6, 7 x 7). **Numbers formed this way are called square numbers.**', 2),
    (uid, '14.4 Triangular numbers', 'Numbers that can be arranged as dots in a triangular shape, like 1, 3, 6 and 10.', '## Triangular Numbers

Consider pipes stacked so that, viewed from the front, they form a triangle — with 1, 2, 3, 4, 5 and 6 pipes in each row from the top. Adding these row counts (1 + 2 + 3 + 4 + 5 + 6) gives 21 pipes in total, and 21 can be arranged as dots in a triangular formation.

**Numbers that can be represented as dots arranged in a triangular formation are called triangular numbers.**

Considering the number of dots in each row:
- 1st triangular number = 1 = 1
- 2nd triangular number = 1 + 2 = 3
- 3rd triangular number = 1 + 2 + 3 = 6
- 4th triangular number = 1 + 2 + 3 + 4 = 10
- 5th triangular number = 1 + 2 + 3 + 4 + 5 = 15

To find any triangular number, start at 1 and keep adding successive whole numbers up to that term''s position.

**Example:** The 10th triangular number is found by adding 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 = **55**.', 3),
    (uid, '14.5 Number patterns', 'Patterns of even, odd, square and triangular numbers arranged by a rule.', '## Number Patterns

A **number pattern** is a list of numbers arranged (for example, in ascending order) according to a mathematical rule. Each number in the pattern is called a **term**.

- **Even number pattern** starting at 2, ascending: 2, 4, 6, 8, 10, ...
- **Odd number pattern** starting at 1, ascending: 1, 3, 5, 7, 9, ...
- **Square number pattern** starting at 9, ascending: 9, 16, 25, 36, ...
- **Triangular number pattern**, ascending: 1, 3, 6, 10, 15, ...

Each of these patterns follows a rule based on the type of number involved (even, odd, square or triangular) — knowing the rule lets us predict later terms in the pattern.', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'If a whole number''s ones digit is 0, 2, 4, 6 or 8 the number is even; if it is 1, 3, 5, 7 or 9 it is odd', 0),
    (uid, 'A prime number has exactly two distinct factors, 1 and itself; 2 is the only even prime number', 1),
    (uid, 'A composite number is a whole number greater than 1 with more than two distinct factors; 1 is neither prime nor composite', 2),
    (uid, 'Square numbers (1, 4, 9, 16...) form a square dot pattern; triangular numbers (1, 3, 6, 10, 15...) form a triangular dot pattern', 3);
end $$;

-- ============================================================
-- 15. Length
-- ============================================================
do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Length', null, '#22C55E', 'meas', 'Learn the units used to measure length, how to convert between them, and how to find the perimeter of a rectilinear plane figure.', 11)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '15.1 Length, height, width, depth and thickness', 'How height, width, depth and thickness are all different ways of describing length.', '## Length, Height, Width, Depth and Thickness

The meaning of **length** is the linear distance from one end to the other.

Height, width, depth and thickness are all different ways of describing length, depending on what is being measured:

| What is measured | Example from the textbook |
|---|---|
| Height | A boy has a height of 135 cm |
| Width | The width of a road is 10 m; the width of a bed is 120 cm |
| Depth | The depth of a fish tank is 40 cm; the depth of a drain is 30 cm |
| Thickness | The thickness of a wooden plank is 20 mm |

The length, width and thickness of an object such as a book are all lengths associated with that object, described using different words depending on which dimension is meant.', 0),
    (uid, '15.2 Measuring tools and units of measurement', 'Rulers, measuring tapes, and the units millimetre, centimetre, metre and kilometre.', '## Measuring Tools and Units of Measurement

Tools used to measure length include rulers and measuring tapes of different kinds and lengths.

**The 15 cm ruler**

A 15 cm ruler has sixteen long lines with equal gaps between them, marked 0, 1, 2, 3, ... up to 15. The gap between every two long lines is further divided into 10 equal parts using short lines.

- The distance between two long lines is **1 centimetre (cm)**.
- The distance between two short lines is **1 millimetre (mm)**.
- So, **10 mm = 1 cm**.

**The metre ruler**

A metre ruler is marked from 0 cm to 100 cm. The length of a hundred centimetres is one metre.

**100 cm = 1 m**

**Measuring tapes and kilometres**

Measuring tapes of different lengths are used for longer distances. The distance between two towns, or the length of a highway, is measured in **kilometres (km)**. A length of 1000 metres is one kilometre.

**1000 m = 1 km**', 1),
    (uid, '15.3 Measuring lengths', 'Reading off the length of an object or line segment using a ruler.', '## Measuring Lengths

To measure the length of an object with a ruler, place one end of the object at the zero line, then read off where the other end lies.

**Example 1:** A strip of paper has one end at the zero line and the other end at 6 cm plus 5 short lines past that. The length of the strip of paper is **6 cm 5 mm**.

**Example 2:** For a line segment PQ, point Q lies at 6 cm 8 mm and point P lies at 1 cm (not at zero). Since P is not at zero, the length of PQ is 1 cm less than 6 cm 8 mm, giving a length of **5 cm 8 mm**.

When reading a ruler, always check whether the starting point is at the zero mark — if not, subtract the starting reading from the ending reading to get the true length.', 2),
    (uid, '15.4 Relationships between units of length', 'Converting lengths between millimetres, centimetres, metres and kilometres.', '## Relationships Between the Different Units of Measuring Length

**Millimetres and centimetres**

Since 10 mm = 1 cm, 1 mm = 1/10 cm = 0.1 cm.

- To express a length given in **centimetres as millimetres**, multiply the number of centimetres by 10.
- To express a length given in **millimetres as centimetres**, divide the number of millimetres by 10.

| Conversion | Worked example |
|---|---|
| cm to mm | 8 cm = 8 x 10 mm = 80 mm |
| mm to cm | 60 mm = 60/10 cm = 6 cm |
| mm to cm + mm | 27 mm = 20 mm + 7 mm = 2 cm 7 mm |
| cm to mm | 0.7 cm = 7 mm (since 0.1 cm = 1 mm) |
| mm to cm | 35 mm = 30 mm + 5 mm = 3 cm + 0.5 cm = 3.5 cm |
| cm to mm | 5.3 cm = 5 cm + 0.3 cm = 50 mm + 3 mm = 53 mm |

**Worked Example:** Three pencils measure red = 13.3 cm, blue = 138 mm, yellow = 12 cm 8 mm. Converting all to millimetres: red = 133 mm, blue = 138 mm, yellow = 128 mm. Since 138 is the largest, the **blue pencil is the longest**.

**Centimetres and metres**

Since 100 cm = 1 m, 1 cm = 1/100 m = 0.01 m.

- To express a length given in **metres as centimetres**, multiply the number of metres by 100.
- To express a length given in **centimetres as metres**, divide the number of centimetres by 100.

| Conversion | Worked example |
|---|---|
| m to cm | 7 m = 100 x 7 cm = 700 cm |
| m + cm to cm | 6 m 23 cm = 600 cm + 23 cm = 623 cm |
| cm to m | 800 cm = 800/100 m = 8 m |
| cm to m + cm | 875 cm = 800 cm + 75 cm = 8 m + 75 cm = 8 m 75 cm |
| m to cm | 7.85 m = 700 cm + 85 cm = 785 cm |
| cm to m | 54 cm = 54/100 m = 0.54 m |

**Metres and kilometres**

Since 1000 m = 1 km:

- To express a length given in **kilometres as metres**, multiply the number of kilometres by 1000.
- To express a length given in **metres as kilometres**, divide the number of metres by 1000.

| Conversion | Worked example |
|---|---|
| km to m | 5 km = 1000 x 5 m = 5000 m |
| km + m to m | 3 km 750 m = 3000 m + 750 m = 3750 m |
| m to km | 5000 m = 5000/1000 km = 5 km |
| m to km + m | 3725 m = 3000 m + 725 m = 3 km 725 m |', 3),
    (uid, '15.5 Estimating the length', 'Using a known reference length to estimate a longer total distance.', '## Estimating Length

Sometimes it is enough to estimate a length rather than measure it exactly, using a known reference length.

**Worked Example:** A linear fence has 27 poles fixed to it, with the distance between two adjacent poles being about 2 m. To estimate the total length of the fence:

- Number of spaces between 27 poles = 26
- Estimated length of the fence = 2 x 26 m = **52 m**', 4),
    (uid, '15.6 Perimeter', 'Finding the perimeter of a plane figure by adding the lengths of all its sides.', '## Perimeter

The **perimeter** of a plane figure is the sum of the lengths of all the sides of that figure. This kind of calculation is used when putting up a fence around land, building a wall, or making a frame for a picture.

**Worked Example 1 — Fencing a plot of land**

A plot of land has four sides of length 40 m, 28 m, 30 m and 45 m.

Length of wire needed = 40 + 28 + 30 + 45 = **143 m**

**Worked Example 2 — Ribbon around a triangular wall hanging**

A triangular wall hanging has sides 68 cm 7 mm, 68 cm 7 mm and 60 cm 4 mm.

- Adding the millimetres: 7 + 7 + 4 = 18 mm = 1 cm 8 mm. Write 8 mm, carry 1 cm.
- Adding the centimetres with the carried 1: 1 + 68 + 68 + 60 = 197 cm.
- So the length of ribbon needed is **197 cm 8 mm**.

**Worked Example 3 — Perimeter of a rectangular ground**

A rectangular ground has length 20 m 75 cm and width 12 m 60 cm.

- Sum of the two lengths: 75 cm + 75 cm = 150 cm = 1 m 50 cm; 1 m + 20 m + 20 m = 41 m. So the two lengths sum to 41 m 50 cm.
- Sum of the two widths: 60 cm + 60 cm = 120 cm = 1 m 20 cm; 1 m + 12 m + 12 m = 25 m. So the two widths sum to 25 m 20 cm.
- Perimeter = 41 m 50 cm + 25 m 20 cm = **66 m 70 cm**.

**Worked Example 4 — Walking around a park**

A girl walks once around a park with sides 115 m 87 cm, 119 m 95 cm, 112 m 50 cm and 110 m 68 cm.

- Adding the centimetres: 87 + 95 + 50 + 68 = 300 cm = 3 m, write 0 cm, carry 3 m.
- Adding the metres with the carried 3: 115 + 119 + 112 + 110 + 3 = 459 m.
- So the distance around the park in one day is 459 m, and in two days it is 459 + 459 = **918 m**.

**Worked Example 5 — Rectangle from width and a length rule**

A rectangle has width 12 cm and length twice its width (24 cm).

Perimeter = 24 + 12 + 24 + 12 = **72 cm**', 5);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '10 mm = 1 cm, 100 cm = 1 m, and 1000 m = 1 km are the key length conversions', 0),
    (uid, 'Height, width, depth and thickness are all ways of describing length depending on what is being measured', 1),
    (uid, 'The perimeter of a plane figure is the sum of the lengths of all its sides', 2),
    (uid, 'When adding lengths given in mixed units (like m and cm), add the smaller unit first and carry over to the larger unit when it reaches 100 (or 1000)', 3);
end $$;

-- Seeds Grade 6 units/concepts/short notes for batch 5, extracted from the
-- official Grade 6 Part-II textbook (Educational Publications Department,
-- Sri Lanka, ISBN 978-955-25-0077-0):
--   16. Liquid Measurements   (pp. 61-72)
--   20. Mass                 (pp. 101-113)
--   18. Algebraic Symbols    (pp. 90-94)
--   19. Constructing Algebraic Expressions and Substitution (pp. 95-100)
--   21. Ratio                (pp. 114-125)
--
-- "Solids" (ch. 17, pp. 73-85) and Revision exercise 2 are intentionally
-- excluded from the e-learning content (hands-on 3D-model based).
--
-- Run after supabase_content_schema.sql.

do $$
declare uid bigint;
begin
  -- 16. Liquid Measurements
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Liquid Measurements', null, '#06B6D4', 'meas', 'Learn the units used to measure quantities of liquids, the relationship between millilitres and litres, and how to add, subtract, and estimate liquid amounts.', 12)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Introduction to Liquid Measurements', 'The units millilitres and litres are used to measure quantities of liquids.', '## Introduction

Liquids such as milk, fruit juice, water, and fuel are sold and measured in bottles and containers of many sizes. The amount of liquid in a container is usually given in **millilitres (ml)** or **litres (l)**.

- Forty millilitres is written using the symbol **40 ml**
- Three hundred and fifty millilitres is written using the symbol **350 ml**
- One litre is written using the symbol **1 l**

**Millilitres and litres** are the two units used to measure quantities of liquids.

- The quantity of milk in a milk packet, or medicinal syrup in a bottle, is usually measured in **millilitres**.
- The fuel used in vehicles is measured in **litres**.', 0),
    (uid, 'Relationship Between Millilitres and Litres', 'Converting liquid measurements between litres and millilitres.', '## The Relationship Between Litres and Millilitres

We have learnt that:

**1 l = 1000 ml**

### Litres to millilitres
To express a quantity given in litres in terms of millilitres, **multiply the number of litres by 1000**.

| Litres | Millilitres |
|---|---|
| 1 l | 1000 ml |
| 2 l | 2000 ml |
| 3 l | 3000 ml |

**Example 1:** Express 12 l in millilitres.
12 l = 12 × 1000 ml = **12 000 ml**

**Example 2:** Express 1 l 200 ml in millilitres.
1 l 200 ml = 1000 ml + 200 ml = **1200 ml**

**Example 3:** Express 4 l 85 ml in millilitres.
4 l 85 ml = 4000 ml + 85 ml = **4085 ml**

### Millilitres to litres
To express a quantity given in millilitres in terms of litres, **divide the number of millilitres by 1000**. When the amount is 1000 ml or more, in terms of litres and millilitres, the millilitres part is always written as a number less than 1000.

**Example:** Express 2750 millilitres in terms of litres and millilitres.
2750 ml = 2000 ml + 750 ml
Since 1000 ml = 1 l, 2000 ml = 2 l
So 2750 ml = **2 l 750 ml**

| ml | l | ml |
|---|---|---|
| 999 | 0 | 999 |
| 1000 | 1 | 000 |
| 2075 | 2 | 075 |
| 3008 | 3 | 008 |', 1),
    (uid, 'Adding Liquid Measurements', 'How to add two or more liquid measurements together.', '## Adding Liquid Measurements

When two liquid amounts are given in the same unit, they can be added directly.

**Example:** 350 ml of fruit juice is added to 750 ml of water.
Quantity of fruit juice = 350 ml
Quantity of water = 750 ml
Total quantity = 1100 ml, that is, **1 l 100 ml**

### Adding measurements given in litres and millilitres
Write the litres in one column and the millilitres in another column. Add the millilitres column first; if the sum is 1000 ml or more, carry 1 litre over to the litres column.

**Example:** A producer of cinnamon oil produced 2 l 750 ml of oil in the first week and 5 l 500 ml in the second week. Find the total quantity of oil produced.

| l | ml |
|---|---|
| 2 | 750 |
| + 5 | 500 |
| **8** | **250** |

750 ml + 500 ml = 1250 ml = 1 l + 250 ml. Write 250 ml in the millilitres column and carry 1 l to the litres column.
1 (carried) + 2 + 5 = 8 l
Total quantity = **8 l 250 ml**

This can be checked by first converting both amounts to millilitres: 2 l 750 ml = 2750 ml, 5 l 500 ml = 5500 ml, so the total is 2750 + 5500 = 8250 ml = 8 l 250 ml.', 2),
    (uid, 'Subtracting Liquid Measurements', 'How to subtract one liquid measurement from another.', '## Subtracting Liquid Measurements

When one liquid measurement is subtracted from another expressed in the same unit, subtract directly.

**Example:** There was 750 ml of water in Sumith''s water bottle. He drank 150 ml of it.
Quantity remaining = 750 ml − 150 ml = **600 ml**

### Subtracting when litres and millilitres are involved
If the millilitres being subtracted are larger than the millilitres available, borrow 1 litre (= 1000 ml) from the litres column.

**Example:** The quantity of drink in a bottle was 2 l 100 ml. 200 ml of it was served to a guest. Find the amount of drink remaining.

2 l 100 ml is equal to 2100 ml.
2100 ml − 200 ml = **1900 ml**, that is, 1 l 900 ml.

Using the column method: since 100 is smaller than 200, carry 1 l from the litres column to the millilitres column. There is then 1000 ml + 100 ml = 1100 ml in the millilitres column.
1100 ml − 200 ml = 900 ml
Only 1 l remains in the litres column.
Remaining amount = **1 l 900 ml**', 3),
    (uid, 'Estimating Liquid Amounts', 'Estimating an approximate quantity of liquid rather than measuring it exactly.', '## Estimating Liquid Amounts

Sometimes we only need an approximate quantity of liquid, rather than an exact measurement — this is called **estimation**.

**Example:** The quantity of milk in a vessel shown in a first figure is approximately 200 ml. A second vessel holds about four times as much milk as the first. Since the amount in the second vessel is about 4 times 200 ml, there is approximately **800 ml** of milk in the second vessel.

Estimation is useful in everyday situations, such as working out roughly how much oil is needed to fill many similar oil lamps, or roughly how much liquid (such as king coconut water) is contained across several similar fruits, based on the approximate quantity found in just one of them.', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '1 litre (l) = 1000 millilitres (ml)', 0),
    (uid, 'To convert litres to millilitres, multiply by 1000; to convert millilitres to litres, divide by 1000', 1),
    (uid, 'When adding or subtracting liquid measurements, keep litres and millilitres in separate columns and carry or borrow using 1000 ml = 1 l', 2),
    (uid, 'Estimating a liquid quantity means finding a sensible approximate amount rather than measuring it exactly', 3);

  -- 20. Mass
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Mass', null, '#3B82F6', 'meas', 'Learn the units used to measure mass, the relationship between grammes and kilogrammes, and how to add and subtract masses given in these units.', 13)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Introduction to Mass', 'Grammes and kilogrammes are the units used to measure mass.', '## Introduction

The **mass** of an object is a measure of the amount of matter in that object. Items such as tea leaves, rice, and sugar are sold in packets marked with their mass in **grammes (g)** or **kilogrammes (kg)**.

- Fifty grammes is written using the symbol **50 g**
- Five hundred grammes is written using the symbol **500 g**
- One kilogramme is written using the symbol **1 kg**

**Grammes and kilogrammes** are the two units used to measure mass. When items are purchased at the market, quantities are most often measured in grammes and kilogrammes.

A **balance scale (weighing scale)** is used to measure the mass of an object by comparing it against one or more standard weights (such as 1 kg, 500 g, 200 g, 100 g, 50 g, 20 g, and 10 g weights). The standard weight is placed in one pan and the object in the other; when the beam of the scale is horizontal, the scale is balanced, and the mass of the object is equal to the standard weight(s) used.', 0),
    (uid, 'Instruments That Measure Mass', 'Balance scales compare mass to standard weights; other scales show the exact mass directly.', '## Instruments That Measure Mass

A balance scale with standard weights can only tell us whether an object''s mass is equal to, more than, or less than a particular standard weight or combination of weights. It cannot easily give the exact mass of an object such as a pumpkin of mass 425 g, which does not match any combination of standard weights exactly.

To find the exact mass of such an object, instruments such as a **kitchen/spring scale** or a **digital weighing scale** are used instead. When the object is placed on the instrument, an indicator or digital display shows its mass directly.

Instruments that measure body mass, such as a bathroom scale, work in the same way — standing on the instrument makes the indicator show your mass.', 1),
    (uid, 'Relationship Between Grammes and Kilogrammes', 'Converting mass measurements between grammes and kilogrammes.', '## The Relationship Between Grammes and Kilogrammes

**1000 g = 1 kg**

The kilogramme is the standard unit used for measuring mass.

### Kilogrammes to grammes
To express a mass given in kilogrammes in terms of grammes, **multiply the number of kilogrammes by 1000**.

**Example 1:** Express 7 kg in grammes.
7 kg = 7 × 1000 g = **7000 g**

**Example 2:** Express 1 kg 250 g in grammes.
1 kg 250 g = 1000 g + 250 g = **1250 g**

### Grammes to kilogrammes
To express a mass given in grammes in terms of kilogrammes, **divide the number of grammes by 1000**. When the mass is 1000 g or more, in terms of kilogrammes and grammes, the grammes part is always written as a number less than 1000.

**Example 1:** Express 9000 g in kilogrammes.
9000 g ÷ 1000 = **9 kg**

**Example 2:** Express 2750 g in kilogrammes and grammes.
2750 g = 2000 g + 750 g. Since 1000 g = 1 kg, 2750 g = **2 kg 750 g**

| g | kg | g |
|---|---|---|
| 999 | 0 | 999 |
| 1000 | 1 | 000 |
| 6075 | 6 | 075 |
| 7009 | 7 | 009 |', 2),
    (uid, 'Adding Masses', 'How to add two or more masses given in grammes and kilogrammes.', '## Adding Masses

When masses are given in the same unit, add them directly.

**Example:** 250 g of sugar is added to 500 g of a food supplement. Total mass = 250 g + 500 g = **750 g**

### Adding masses given in kilogrammes and grammes
Write the kilogrammes in one column and the grammes in another column. Add the grammes column first; if the sum is 1000 g or more, carry 1 kilogramme over to the kilogrammes column.

**Example:** Add 2 kg 750 g and 1 kg 450 g.

| kg | g |
|---|---|
| 2 | 750 |
| + 1 | 450 |
| **4** | **200** |

750 g + 450 g = 1200 g = 1 kg + 200 g. Write 200 g and carry 1 kg to the kilogrammes column.
1 (carried) + 2 + 1 = 4 kg
Total = **4 kg 200 g**', 3),
    (uid, 'Subtracting Masses', 'How to subtract one mass from another given in grammes and kilogrammes.', '## Subtracting Masses

When masses are given in the same unit, subtract directly.

**Example:** A housewife left 2 kg 750 g of black pepper out in the sun to dry. After drying it weighed 1 kg 200 g. The mass lost during drying = 2 kg 750 g − 1 kg 200 g = **1 kg 550 g**

### Subtracting when the grammes cannot be subtracted directly
If the grammes to be subtracted are larger than the grammes available, borrow 1 kilogramme (= 1000 g) from the kilogrammes column and add it to the grammes column.

**Example:** A box containing biscuits has a mass of 2 kg 250 g. The empty box has a mass of 750 g. Find the mass of the biscuits.

Since 750 g cannot be subtracted from 250 g, convert 1 kg from the kilogrammes column into grammes and add it: 1000 g + 250 g = 1250 g.
1250 g − 750 g = 500 g
Only 1 kg remains in the kilogramme column (2 kg − 1 kg borrowed).
Mass of the biscuits = **1 kg 500 g**', 4);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '1 kilogramme (kg) = 1000 grammes (g)', 0),
    (uid, 'To convert kilogrammes to grammes, multiply by 1000; to convert grammes to kilogrammes, divide by 1000', 1),
    (uid, 'A balance scale compares an object''s mass with standard weights; scales with a dial or digital display show the exact mass', 2),
    (uid, 'When adding or subtracting kg and g, keep them in separate columns and carry or borrow using 1000 g = 1 kg', 3);

  -- 18. Algebraic Symbols
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Algebraic Symbols', null, '#5B4FE5', 'alg', 'Learn to identify known terms, unknown terms, and variables, and understand how letters are used as algebraic symbols to represent them.', 14)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Symbols Used in Maths', 'The digits and operation symbols used to write mathematical statements.', '## Symbols Used in Mathematics

The ten symbols 0, 1, 2, 3, 4, 5, 6, 7, 8, and 9 are called **digits**. These are the symbols of the Hindu-Arabic number system, and every number is written using combinations of these ten digits.

Other symbols used in mathematics represent operations:

| Mathematical operation | Symbol |
|---|---|
| Addition | + |
| Subtraction | − |
| Multiplication | × |
| Division | ÷ |

Mathematical statements can be written using digits together with these operation symbols and the equals sign (=).

**Example:** The statement "thirteen is obtained by adding five to eight" is expressed using symbols as **8 + 5 = 13**.

**Example:** The statement "three twos is six" is expressed as **2 × 3 = 6**, and "two threes is six" is expressed as **3 × 2 = 6**.', 0),
    (uid, 'Known and Unknown Terms', 'The difference between a known constant value and an unknown constant value.', '## Known and Unknown Terms

A **known term** is a constant value that we already know, and it is expressed using a number.

**Example:** "There are seven days in a week" is written as "7 days in a week" — here, 7 is a known term, because it is a constant value that is known.

An **unknown term** (an "unknown") is a constant value that we do not know, so it cannot be expressed directly using a number. Instead, it is represented using a letter of the English alphabet.

**Example:** Suppose a household buys the same fixed amount of milk every day, but that amount is not known to us. Since it is a constant but unknown value, we can represent it using a letter, such as **a**.

Symbols used to represent unknown terms, like the letter *a* above, are called **algebraic symbols**.

**More examples of unknown terms represented using algebraic symbols:**
- The length of your classroom is **l** metres.
- The number of books in your school library is **n**.
- The height of the flag pole is **h** metres.', 1),
    (uid, 'Variables', 'Quantities that do not have one fixed value are called variables.', '## Variables

A **variable** is a quantity whose value is not fixed — it can take different values depending on the situation.

**Example:** At a market, coconuts of various prices are sold by different sellers. Since the selling price of a coconut does not take one fixed value, we say that the price of a coconut is a **variable**.

Variables are denoted using English letters such as **x, y, z, ...**. These, too, are **algebraic symbols**.

**Example:**
- The daily revenue of a certain shop is Rs *x*.
- The distance a vehicle travels during an hour is *y* km.
- The distance travelled by a vehicle on one litre of petrol is *x* km.
- The number of days in the month of February is *n* (it is not fixed — it is 28 or 29 depending on the year).

### Summary
- Constant values which are known are called **known terms**.
- Constant values which are not known are called **unknown terms (unknowns)**.', 2);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A known term is a constant value we already know, such as 7 in "7 days in a week"', 0),
    (uid, 'An unknown term (unknown) is a constant value that is not known, represented using a letter such as a or n', 1),
    (uid, 'A variable is a quantity that does not have one fixed value, denoted with letters like x, y, z', 2),
    (uid, 'Letters used to represent unknowns and variables are together called algebraic symbols', 3);

  -- 19. Constructing Algebraic Expressions and Substitution
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Constructing Algebraic Expressions and Substitution', null, '#EC4899', 'alg', 'Learn to construct algebraic expressions using algebraic symbols, and find the value of an expression containing one unknown by substituting a whole number for it.', 15)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Constructing Algebraic Expressions', 'Building expressions that use algebraic symbols to represent real situations.', '## Constructing Algebraic Expressions

We can build mathematical expressions containing algebraic symbols to represent real-life situations.

**Example:** Chalani had 4 exercise books. She received a parcel containing an unknown number of exercise books from her uncle. Let the number of books in the parcel be **n**.

- Number of books Chalani originally had = 4
- Number of books received in the parcel = n
- Total number of books Chalani now has = **4 + n** (this can also be written as n + 4)

An expression such as 4 + n, which contains an algebraic symbol, is called an **algebraic expression**.

**Example:** 5 marbles are removed from a bag containing an unknown number of marbles, taken to be **a**.

- Number of marbles that were in the bag = a
- Number of marbles taken out = 5
- Number of marbles remaining in the bag = **a − 5**

**Worked Example:** There are 45 students in a class. If the number of boys in the class is taken to be **m**, construct an algebraic expression for the number of girls in the class.

Number of girls in the class = Total number of students − Number of boys
= **45 − m**', 0),
    (uid, 'Substitution', 'Finding the value of an algebraic expression by assigning a number to the unknown.', '## Substitution

**Substitution** is assigning a numerical value to an unknown term or a variable in an algebraic expression. By substitution, an algebraic expression takes on a numerical value.

**Example:** Consider the algebraic expression x + 6.

- When x = 2: x + 6 = 2 + 6 = 8
- When x = 4: x + 6 = 4 + 6 = 10
- When x = 8: x + 6 = 8 + 6 = 14

| Algebraic expression | Value substituted for the unknown | Expression after substitution | Value of the expression |
|---|---|---|---|
| x + 7 | 3 | 3 + 7 | 10 |
| y + 50 | 14 | 14 + 50 | 64 |
| a − 3 | 8 | 8 − 3 | 5 |
| p − 14 | 20 | 20 − 14 | 6 |

**Worked Example:** Find the value of the expression x − 4 when x = 5.
When x = 5: x − 4 = 5 − 4 = **1**

### Summary
- Algebraic expressions are expressions which contain algebraic terms.
- Substitution is assigning a numerical value to an unknown term or a variable term in an algebraic expression.', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'An algebraic expression is a mathematical statement containing at least one algebraic symbol, e.g. 4 + n or a - 5', 0),
    (uid, 'Substitution means replacing the unknown or variable in an expression with a specific number', 1),
    (uid, 'To evaluate x + 6 when x = 4, substitute the value: 4 + 6 = 10', 2),
    (uid, 'Words like "total" or "together" often signal addition, while "remaining" or "removed" often signal subtraction when building an expression', 3);

  -- 21. Ratio
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Ratio', null, '#F59E0B', 'frac', 'Learn to understand the concept of a ratio of two quantities, write equivalent ratios, express a ratio in its simplest form, and understand the difference between a ratio and a rate.', 16)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, 'Introduction to Ratio', 'A ratio compares the amounts of two or more quantities expressed in the same unit.', '## Introduction to Ratio

A **ratio** is a numerical relationship between the amounts of two or more quantities that are expressed using the same unit. A ratio can also compare the amounts in two groups that are being compared.

**Example:** A fruit-juice label shows that one part fruit juice should be mixed with five parts water. The ratio of fruit juice to water is **1 : 5**. Here, ":" is the symbol of ratio, and 1 and 5 are its **terms** — the first term is 1 and the second term is 5. Since a ratio does not change with the units used to measure the quantities, it is not necessary to state a unit when writing a ratio.

**More examples:**
- A person spends Rs 7 and saves Rs 3 out of every Rs 10 earned. The ratio of spending to savings = **7 : 3**.
- Light blue paint is made by mixing one part dark blue paint with two parts white paint. The ratio of dark blue paint to white paint = **1 : 2**.

**Worked Example 1:** The length of a rectangle is 12 cm and the breadth is 7 cm. Find the ratio of the length to the breadth.
Ratio of length to breadth = **12 : 7**

**Worked Example 2:** The price of a small envelope is 50 cents and the price of a large envelope is Rs 2. Find the ratio of the price of the small envelope to the price of the large envelope.
Since the two prices must be expressed in the same unit, Rs 2 = 200 cents.
Ratio of the price of the small envelope to the large envelope = **50 : 200**', 0),
    (uid, 'Equivalent Ratios', 'Ratios that look different but represent the same relationship between quantities.', '## Equivalent Ratios

Ratios that represent the same relationship between quantities, even though their terms look different, are called **equivalent ratios**.

**Example:** A concrete mixture is made with cement and sand in the ratio 1 : 3.

| Cement | Sand | Ratio |
|---|---|---|
| 1 | 3 | 1 : 3 |
| 2 | 6 | 2 : 6 |
| 3 | 9 | 3 : 9 |
| 4 | 12 | 4 : 12 |
| 5 | 15 | 5 : 15 |

So 1 : 3 = 2 : 6 = 3 : 9 = 4 : 12 = 5 : 15 — all of these are equivalent ratios.

**A ratio equivalent to a given ratio can be obtained by multiplying each term of the ratio by the same number (greater than zero).** Equivalent ratios can also be obtained by dividing both terms by the same number.

**Example:** Write down two ratios equivalent to 2 : 5.
- Multiplying both terms by 2: 2 : 5 = 4 : 10
- Multiplying both terms by 3: 2 : 5 = 6 : 15

So 4 : 10 and 6 : 15 are two ratios equivalent to 2 : 5.

**Example (using division):** A mixture of 2 l of lime juice mixed with 4 l of water has ratio 2 : 4. The same composition is obtained by mixing 1 l of lime juice with 2 l of water — dividing both terms of 2 : 4 by 2 gives 1 : 2. So 2 : 4 and 1 : 2 are equivalent ratios.', 1),
    (uid, 'Simplest Form of a Ratio', 'Reducing a ratio to its lowest whole-number terms.', '## Writing a Ratio in Its Simplest Form

Consider the equivalent ratios 8 : 12 = 4 : 6 = 2 : 3 = 6 : 9 = 10 : 15.

A ratio is in its **simplest form** when both terms are whole numbers and there is no whole number (other than 1) that can divide both terms exactly.

So **2 : 3** is the simplest form of 8 : 12, 4 : 6, 6 : 9, and 10 : 15.

**To write a ratio in its simplest form, keep dividing both terms by the same number until you cannot go any further without going into decimals.**

**Example 1:** Write the ratio 9 : 15 in its simplest form.
9 : 15 = (9 ÷ 3) : (15 ÷ 3) = **3 : 5**

**Example 2:** Write the ratio 18 : 24 in its simplest form.
18 : 24 = (18 ÷ 2) : (24 ÷ 2) = 9 : 12 = (9 ÷ 3) : (12 ÷ 3) = **3 : 4**

**Worked Example:** The breadth of a blackboard is 50 cm and its length is 1 m 25 cm. Find the ratio of the breadth to the length of the blackboard, in its simplest form.
1 m 25 cm = 125 cm
50 : 125 = (50 ÷ 5) : (125 ÷ 5) = 10 : 25 = (10 ÷ 5) : (25 ÷ 5) = **2 : 5**', 2),
    (uid, 'Rate', 'A relationship between two quantities measured in different units.', '## Rate

**Rate** is a relationship between two quantities that are measured in *different* units, and so cannot be expressed as a ratio.

**Example:** 10 eggs are used to make 1 kg of cake; a vehicle travels 12 km on 1 litre of oil; the price of 10 guavas is Rs 100. In each case, the two quantities involved (eggs and kg, km and litres, rupees and guavas) are measured in different units, so these are rates, not ratios.

**Other examples of rate:**
- The price of a pencil is Rs 10.
- Rs 40 is charged to travel 1 km in a vehicle.
- Students present at a function each received 3 biscuits.

An **exchange rate** is the relationship between two different currencies — for example, the value of a United States dollar in Sri Lanka on a given day. Since exchange rates change daily, the date must always be stated when mentioning an exchange rate.

**Example:** The price of an exercise book is Rs 20. Find the price of 4 such books.
Price of 4 books = Rs 20 × 4 = **Rs 80**

**Example:** If the price of 5 pencils is Rs 100, find the price of 2 pencils.
Price of a pencil = Rs 100 ÷ 5 = Rs 20
Price of 2 pencils = Rs 20 × 2 = **Rs 40**

### Summary
- A ratio equivalent to a given ratio can be obtained by multiplying or dividing each term of the ratio by the same number (greater than zero).
- A ratio is in its simplest form when both terms are whole numbers with no common whole-number divisor other than 1.
- Rate is a relationship between quantities measured in different units.', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A ratio, such as 1 : 5, compares two quantities measured in the same unit', 0),
    (uid, 'Multiplying or dividing both terms of a ratio by the same number gives an equivalent ratio', 1),
    (uid, 'A ratio is in its simplest form when its terms share no common divisor other than 1, e.g. 2 : 3', 2),
    (uid, 'Rate compares quantities measured in different units, such as price per item or distance per litre of fuel', 3);
end $$;

-- Grade 6 seed batch 6
-- Chapters: Data Collection and Representation, Data Interpretation, Indices, Area
-- Source: Educational Publications Department, Grade 6 Maths Pupil's Book Part II (ISBN 978-955-25-0077-0)

do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Data Collection and Representation', null, '#00D9C0', 'stat', 'Learn how to collect data using tally marks, and how to represent collected data in tables and picture graphs.', 17)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '22.1 Collecting data using tally marks', 'Recording observations quickly using tally marks grouped in fives.', '## Tally Marks

**Information that can be represented using numbers is called data.** Information such as the daily attendance of students in a school, or the number of births recorded in a hospital, is presented as data.

When we need to count how many times something occurs (for example, the different types of vehicles that arrive at an office), we can record each occurrence as it happens using a **tally mark**. Each time an item is observed, a small line segment ( / ) is drawn next to its category.

Counting single tally marks one by one becomes slow once the numbers get large. A better method is to group tally marks in **sets of five**: the first four occurrences are drawn as four separate line segments, and the fifth occurrence is drawn as a line crossing through the previous four. This makes it easy to count large totals quickly by counting the groups of five and then adding any leftover single marks.

**Example — vehicles arriving at an office**

Two students each kept a tally of the vehicles that arrived at an office on a normal day. Counting the completed tally marks (grouped in fives) gave the following totals:

| Type of Vehicle | Number of Vehicles |
|---|---|
| Car | 15 |
| Van | 4 |
| Motorcycle | 42 |
| Bicycle | 28 |

It is much easier and quicker to count tally marks that have been grouped into sets of five than to count single tally marks one by one.', 0),
    (uid, '22.2 Representing data using picture graphs', 'Representing data using symbols, where one symbol stands for a fixed number of items.', '## Picture Graphs

A **picture graph** represents data using symbols instead of numbers. When a picture graph is drawn, the **number of data items represented by one symbol must always be indicated**, since this is not something the reader can otherwise guess.

**Choosing a symbol:** If a symbol is chosen to represent just one item, then very large data values would need huge numbers of symbols to be drawn, which is impractical. Instead, a number is chosen (one that divides all the given data values, or divides most of them with a manageable remainder) and one symbol is used to represent that many items. If a data value does not divide exactly, part-symbols (such as a half symbol) can be used to represent the remainder.

**Worked Example**

The number of popsicles sold by an ice cream seller over 5 days is:

| Day | Number of Popsicles |
|---|---|
| Monday | 72 |
| Tuesday | 120 |
| Wednesday | 144 |
| Thursday | 60 |
| Friday | 132 |

All these numbers divide exactly by 12, so **12 popsicles** are represented by one symbol. Dividing each day''s value by 12 gives the number of symbols needed:

- Monday: 72 ÷ 12 = 6 symbols
- Tuesday: 120 ÷ 12 = 10 symbols
- Wednesday: 144 ÷ 12 = 12 symbols
- Thursday: 60 ÷ 12 = 5 symbols
- Friday: 132 ÷ 12 = 11 symbols

A picture graph can then be drawn showing this many symbols in a row for each day, with a note stating "12 popsicles are represented by the symbol [chosen symbol]".

Sometimes a data value does not divide the chosen number exactly. In such cases, a fraction of the symbol (such as a half or a quarter of it) can be drawn to represent the remaining items, as long as the amount represented by a half or a quarter of the symbol can be worked out sensibly.', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Tally marks are grouped in sets of five (the fifth mark crosses the previous four) so large totals can be counted quickly', 0),
    (uid, 'Information that can be represented using numbers is called data', 1),
    (uid, 'A picture graph represents data using symbols, and must always state how many items one symbol represents', 2),
    (uid, 'When a data value does not divide the chosen symbol value exactly, a half or a quarter of the symbol can be used for the remainder', 3);
end $$;

do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Data Interpretation', null, '#A855F7', 'stat', 'Learn how to interpret data that has been represented in tables and picture graphs, and draw conclusions from it.', 18)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '23.1 Interpreting data represented in tables', 'Drawing conclusions such as totals, differences, highest/lowest values and ratios from a table of data.', '## Interpreting Tables

**Drawing various pieces of information from data represented in picture graphs and tables is known as data interpretation.**

**Worked Example**

The following table shows the number of 175 ml fruit juice bottles sold by a company during the first five months of 2014:

| Month | Number of Bottles |
|---|---|
| January | 30 000 |
| February | 32 100 |
| March | 31 500 |
| April | 34 800 |
| May | 33 000 |

Using this table, several conclusions can be drawn:

1. **Difference between two months:** the extra bottles sold in February compared to January = 32 100 − 30 000 = **2 100**.
2. **Total over two months:** total sales in March and April = 31 500 + 34 800 = **66 300**.
3. **Highest and lowest:** sales were **highest in April** (34 800 bottles) and **lowest in January** (30 000 bottles).
4. **Ratio in simplest form:** the ratio of bottles sold in January to bottles sold in May = 30 000 : 33 000 = 30 : 33 = **10 : 11** (dividing both terms by 1000, then by 3).

These examples show that once data is set out in a table, subtraction, addition, comparison and ratio can all be used to interpret it.', 0),
    (uid, '23.2 Interpretation of data represented in picture graphs', 'Reading conclusions directly off a picture graph by using the value that one symbol represents.', '## Interpreting Picture Graphs

When data has been represented in a picture graph, conclusions can be drawn by counting the symbols for each category and using the value that one symbol represents.

**Worked Example**

The number of vehicles joining a highway during a certain hour, through a certain entry point, was represented in a picture graph for five vehicle types — Cars, Buses, Vans, Jeeps and Lorries — where **10 vehicles are represented by one symbol**.

From reading the picture graph, the following conclusions could be stated:

- The type of vehicle that joined the highway **most** during this hour is **cars**.
- The type of vehicle that joined the highway **least** during this hour is **jeeps**.
- The number of **lorries** that joined the highway during this hour is **20**.
- The **total** number of vehicles that joined the highway during this hour is **105**.
- The number of vehicles **other than lorries** that joined the highway is **85**.
- The number of **vans** that joined the highway is **five times** the number of jeeps.

This shows that once a symbol''s value is known, a picture graph can be used to compare categories, find totals, and describe relationships between categories, in the same way a table can.', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Data interpretation means drawing conclusions from data given in a table or a picture graph', 0),
    (uid, 'To find how much more one value is than another, subtract the smaller value from the larger one', 1),
    (uid, 'The highest and lowest values in a set of data can be read directly from a table or picture graph', 2),
    (uid, 'A ratio can be used to compare two values in a data set, and should be written in its simplest form', 3);
end $$;

do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Indices', null, '#8B5CF6', 'alg', 'Learn to recognize index notation, write a repeated product concisely as a power of a number, and express a number as a power of another given number.', 19)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '24.1 Index notation', 'Writing a number that is multiplied repeatedly by itself concisely, using a base and an index.', '## Index Notation

When a number is multiplied repeatedly by itself, it can be written concisely using **index notation**. For example, 2 × 2 × 2 is written as **2³**.

The small digit written at the top right of the number shows how many times the number is multiplied by itself. In 2³, the number **2 is called the base** and **3 is called the index**. This is read as "two to the power of three" (or "two to the power three"). The value of 2³ equals the value of 2 × 2 × 2, which is **8**.

- A number to the power two is also called the **square** of the number (e.g. 5² is "five squared").
- A number to the power three is also called the **cube** of the number (e.g. 8³ is "eight cubed").

**Example 1:** Write 3 × 3 × 3 × 3 using index notation.
3 × 3 × 3 × 3 = **3⁴**

**Example 2:** Find the value of 2⁶.
2⁶ = 2 × 2 × 2 × 2 × 2 × 2 = **64**

A product can also combine more than one base written in index form.

**Example 3:** Write 2 × 2 × 2 × 5 × 5 using indices.
2 × 2 × 2 × 5 × 5 = **2³ × 5²**

**Example 4:** Find the value of 5² × 7³.
5² × 7³ = 5 × 5 × 7 × 7 × 7 = **8575**', 0),
    (uid, '24.2 Representing a number as a power of a given number', 'Finding the index needed to express a given number as a power of a stated base, using repeated division.', '## Expressing a Number as a Power

To express a number as a power of a given base, we need to find out how many times the base must be multiplied by itself to obtain that number. This can be found using **repeated division**: divide the given number repeatedly by the base until the result is 1, and count how many times the division was carried out — that count is the index.

**Example:** Express 16 as a power of 2.

16 ÷ 2 = 8
8 ÷ 2 = 4
4 ÷ 2 = 2
2 ÷ 2 = 1

Since 2 was used as a divisor 4 times, 16 = 2 × 2 × 2 × 2 = **2⁴**.

**Example 1:** Express 81 as a power of 3.
81 ÷ 3 = 27, 27 ÷ 3 = 9, 9 ÷ 3 = 3, 3 ÷ 3 = 1 (divided by 3 four times)
81 = 3 × 3 × 3 × 3 = **3⁴**

**Example 2:** Express 125 as a power of 5.
125 ÷ 5 = 25, 25 ÷ 5 = 5, 5 ÷ 5 = 1 (divided by 5 three times)
125 = 5 × 5 × 5 = **5³**', 1);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Index notation writes a repeated product concisely, e.g. 2 × 2 × 2 × 2 × 2 = 2⁵', 0),
    (uid, 'In 2⁵, 2 is the base and 5 is the index, read as ''two to the power of five''', 1),
    (uid, 'A number to the power two is called its square; a number to the power three is called its cube', 2),
    (uid, 'To express a number as a power of a given base, divide the number repeatedly by that base and count the divisions', 3);
end $$;

do $$
declare uid bigint;
begin
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Area', null, '#FF7A45', 'geo', 'Learn what area means, how to measure it using arbitrary units and the standard unit cm², and how figures of different shapes can share the same area.', 20)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, body, sort_order) values
    (uid, '25.1 Identifying what area is', 'Understanding area as the amount of space occupied by a flat surface.', '## What is Area?

Consider a space on a wall that has been divided up so that several students can each display their creations, with each student''s space bounded by line segments (some rectangular, some circular, some triangular in shape).

**The space occupied by a surface is known as its area.**

When two spaces have been given similar shapes but different sizes, the one that looks bigger clearly occupies more space — that is, it has a **larger area** — even without measuring it precisely. This everyday idea of "how much space a flat shape covers" is the starting point for measuring area formally.', 0),
    (uid, '25.2 Measuring the area using arbitrary units', 'Measuring area by counting how many identical unit shapes fit into a figure, and introducing the square centimetre.', '## Measuring Area with Unit Squares

The area of a shape can be measured by taking some other flat shape (called a **lamina**) as one unit, and finding out how many times that unit lamina fits into the shape being measured — this is called measuring area using an **arbitrary unit**.

If the *same* rectangular shape is measured using two *different* sized unit laminas, two *different* numbers are obtained (for example, one unit lamina might give an area of 24 units, while a differently sized unit lamina gives an area of 6 units for the very same rectangle). This shows that **whenever an area is stated, the unit used to measure it must also be stated**, since the number alone does not mean anything without knowing the size of the unit.

**The standard unit:** A square lamina with side length 1 cm is used as a standard unit for measuring area. This is called **one square centimetre**, written **1 cm²**.

**Example 1:** Find the area of a figure made up of small squares, where each small square has an area of 1 cm².
If the figure contains 15 such small squares, then since the area of one square is 1 cm², the **area of the figure = 15 cm²**.

**Example 2:** Find the area of a triangular figure drawn on a 1 cm² grid.
If the figure contains 6 complete small squares and 4 half-squares, the four half-squares together make up 2 more complete squares. So the total area = 6 + 2 = **8 cm²**.

These examples show that the area of any figure drawn on a 1 cm × 1 cm grid can be found simply by counting the number of unit squares (including combining half-squares where a figure''s edge cuts through a square) that make up the figure.', 1),
    (uid, '25.3 Constructing plane figures using 1 cm² laminas', 'Understanding that figures of different shapes can have the same area if built from the same number of unit squares.', '## Same Area, Different Shapes

Several different composite figures can be created by joining together identical 1 cm² square laminas. Even though such figures may look very different from each other in shape, if each one is made up of the **same number** of 1 cm² unit squares, then **each figure has exactly the same area**.

For example, three visually different figures, each built by joining four 1 cm² square laminas together, all have an area of **4 cm²**, regardless of their overall shape.

This idea also works in reverse: larger squares (such as a square of side length 2 cm, 3 cm or 4 cm) can be shown to be made up of a certain number of 1 cm² unit squares, and their area can be found simply by counting how many unit squares fit inside them.', 2);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Area is the amount of space occupied by a flat surface', 0),
    (uid, 'Area can be measured using any arbitrary unit, but the unit used must always be stated alongside the number', 1),
    (uid, 'The area of a 1 cm × 1 cm square is the standard unit of area, called one square centimetre (1 cm²)', 2),
    (uid, 'Figures of different shapes can have the same area if they are made up of the same number of unit squares', 3);
end $$;

