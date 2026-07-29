-- Seeds Grade 6 units/concepts/short notes — migrated from the previous
-- hardcoded app/lib/data.ts mock content (already reviewed curriculum
-- content, just moved into the database). Run after supabase_content_schema.sql.
--
-- Grades 7-8 (and later up to 11) are intentionally NOT seeded here: that's
-- real curriculum content only you can author correctly. Insert new rows
-- into `units` / `concepts` / `short_notes` with the appropriate `grade`
-- once you have that content ready — the API and frontend already support
-- any grade with no code changes needed.

do $$
declare uid bigint;
begin
  -- 1. Numbers
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Numbers', 'අංක', '#5B4FE5', 'hash', 'Learn about place values, reading big numbers, and rounding off', 0)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Place Values', 'Understanding the value of each digit in a number', 0),
    (uid, 'Reading Large Numbers', 'How to read and write numbers up to millions', 1),
    (uid, 'Rounding Numbers', 'Round to the nearest 10, 100, or 1000', 2),
    (uid, 'Number Patterns', 'Find the rule and continue a number pattern', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Place value tells us what each digit is worth — ones, tens, hundreds, thousands', 0),
    (uid, '5,432,109 is read as ''five million four hundred and thirty-two thousand one hundred and nine''', 1),
    (uid, 'To round: look at the digit after the place — 5 or more, round up', 2),
    (uid, 'Patterns follow a rule — find it to predict the next numbers', 3);

  -- 2. Four Operations
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Four Operations', 'මූලික ක්‍රියා', '#8B5CF6', 'ops', 'Master addition, subtraction, multiplication and division with big numbers', 1)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Addition', 'Adding large numbers with carrying', 0),
    (uid, 'Subtraction', 'Subtracting with borrowing', 1),
    (uid, 'Multiplication', 'Multi-digit multiplication methods', 2),
    (uid, 'Division', 'Long division step by step', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Always line up digits by place value when adding or subtracting', 0),
    (uid, 'Multiply each digit then add the partial results together', 1),
    (uid, 'Long division: Divide, Multiply, Subtract, Bring down, Repeat', 2),
    (uid, 'Check your answer: quotient × divisor + remainder = original number', 3);

  -- 3. Fractions
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Fractions', 'භාග', '#00D9C0', 'frac', 'Understand parts of a whole and work with different types of fractions', 2)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Types of Fractions', 'Proper, improper and mixed fractions', 0),
    (uid, 'Equivalent Fractions', 'Fractions that look different but are equal', 1),
    (uid, 'Adding & Subtracting', 'Working with same and different denominators', 2),
    (uid, 'Multiplying Fractions', 'Multiply numerators and denominators', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Proper: numerator < denominator (3/4). Improper: numerator > denominator (7/4)', 0),
    (uid, 'Mixed fraction: whole number + proper fraction, like 1 3/4', 1),
    (uid, 'To add fractions with different denominators, find the LCD first', 2),
    (uid, 'Multiply straight across: a/b × c/d = ac/bd', 3);

  -- 4. Decimals
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Decimals', 'දශම', '#FF7A45', 'dec', 'Work with decimal numbers, convert them, and do calculations', 3)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Decimal Place Value', 'Tenths, hundredths, and thousandths', 0),
    (uid, 'Fractions to Decimals', 'How to convert between the two', 1),
    (uid, 'Decimal Operations', 'Add, subtract, multiply decimals', 2),
    (uid, 'Rounding Decimals', 'Round to given decimal places', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '3.14 means 3 whole and 14 hundredths — the dot separates wholes from parts', 0),
    (uid, 'To convert fraction to decimal: divide numerator by denominator', 1),
    (uid, 'When adding or subtracting, always line up the decimal points', 2),
    (uid, 'To multiply: ignore the decimal, multiply, then put it back', 3);

  -- 5. Integers
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Integers', 'පූර්ණ සංඛ්‍යා', '#3B82F6', 'int', 'Explore positive and negative numbers on the number line', 4)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Positive & Negative', 'Understanding integers on a number line', 0),
    (uid, 'Comparing Integers', 'Which is bigger? Using < and > signs', 1),
    (uid, 'Adding Integers', 'Rules for adding positive and negative numbers', 2),
    (uid, 'Subtracting Integers', 'Two negatives make a positive', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Integers include ..., -3, -2, -1, 0, 1, 2, 3, ...', 0),
    (uid, 'Positive numbers are always greater than negative numbers', 1),
    (uid, 'Same signs: add and keep the sign. (+3)+(+5)=+8', 2),
    (uid, 'Different signs: subtract and take the sign of the bigger number', 3);

  -- 6. Algebra
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Algebra', 'වීජ ගණිතය', '#EC4899', 'alg', 'Use letters and symbols to represent numbers and solve problems', 5)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Variables', 'Letters like x, y, n that stand for unknown numbers', 0),
    (uid, 'Expressions', 'Writing math sentences with letters and numbers', 1),
    (uid, 'Simple Equations', 'Finding the unknown value using = sign', 2),
    (uid, 'Solving Equations', 'Step by step — do the same to both sides', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A variable represents an unknown number — like a box waiting to be filled', 0),
    (uid, 'Expression: 3x + 5 means ''3 times x, then add 5''', 1),
    (uid, 'Equation has an = sign: 2x + 3 = 11', 2),
    (uid, 'Solve by doing the same operation to both sides until x is alone', 3);

  -- 7. Geometry
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Geometry', 'ජ්‍යාමිතිය', '#F59E0B', 'geo', 'Study shapes, angles, lines and their special properties', 6)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Points, Lines & Angles', 'The building blocks of geometry', 0),
    (uid, 'Types of Angles', 'Acute, right, obtuse, straight and reflex', 1),
    (uid, 'Triangles', 'Types and properties of triangles', 2),
    (uid, 'Quadrilaterals', 'Squares, rectangles, parallelograms and more', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'A point has no size, a line goes on forever, a segment has two ends', 0),
    (uid, 'Right angle = 90°, Acute < 90°, Obtuse between 90° and 180°', 1),
    (uid, 'Angles in a triangle always add up to 180°', 2),
    (uid, 'Square: all sides equal, all angles 90°', 3);

  -- 8. Measurement
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Measurement', 'මිනුම්', '#22C55E', 'meas', 'Measure length, area, volume and perimeter of shapes', 7)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Length', 'Measuring and converting between units', 0),
    (uid, 'Perimeter', 'The distance around the outside of a shape', 1),
    (uid, 'Area', 'The space inside a flat shape', 2),
    (uid, 'Volume', 'The space inside a 3D object', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, '1 km = 1000 m, 1 m = 100 cm, 1 cm = 10 mm', 0),
    (uid, 'Perimeter of rectangle = 2 × (length + width)', 1),
    (uid, 'Area of rectangle = length × width', 2),
    (uid, 'Volume of cuboid = length × width × height', 3);

  -- 9. Statistics
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Statistics', 'සංඛ්‍යානය', '#06B6D4', 'stat', 'Collect, organise and understand data using graphs and averages', 8)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Collecting Data', 'How to gather and organise information', 0),
    (uid, 'Bar Graphs', 'Drawing and reading bar charts', 1),
    (uid, 'Mean (Average)', 'Finding the average of a set of numbers', 2),
    (uid, 'Mode & Range', 'Most common value and the spread of data', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Data is collected information — numbers, facts, or measurements', 0),
    (uid, 'Bar graph: taller bar means a bigger number', 1),
    (uid, 'Mean = sum of all values ÷ how many values there are', 2),
    (uid, 'Mode = most frequent value. Range = biggest − smallest', 3);

  -- 10. Patterns
  insert into public.units (grade, name, sinhala_name, accent_color, icon_key, description, sort_order)
  values (6, 'Patterns', 'රටා', '#A855F7', 'pat', 'Find and describe number patterns and relationships between things', 9)
  returning id into uid;

  insert into public.concepts (unit_id, name, description, sort_order) values
    (uid, 'Number Sequences', 'Finding the rule in a number pattern', 0),
    (uid, 'Shape Patterns', 'Patterns made with shapes that change', 1),
    (uid, 'Growing Patterns', 'Patterns that grow bigger step by step', 2),
    (uid, 'Relationships', 'How two things change together', 3);

  insert into public.short_notes (unit_id, content, sort_order) values
    (uid, 'Find the difference between numbers to discover the pattern rule', 0),
    (uid, 'If the difference is the same each time, it is a linear pattern', 1),
    (uid, 'Shape patterns change in colour, size, rotation, or number', 2),
    (uid, 'A relationship connects two things, like hours worked and money earned', 3);
end $$;
