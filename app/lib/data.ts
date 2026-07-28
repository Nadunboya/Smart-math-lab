export interface Concept {
  id: string;
  name: string;
  desc: string;
}

export interface Unit {
  id: number;
  name: string;
  sinhala: string;
  accent: string;
  iconKey: string;
  desc: string;
  concepts: Concept[];
  notes: string[];
}

export const grade6Units: Unit[] = [
  {
    id: 1,
    name: "Numbers",
    sinhala: "අංක",
    accent: "#5B4FE5",
    iconKey: "hash",
    desc: "Learn about place values, reading big numbers, and rounding off",
    concepts: [
      {
        id: "c1-1",
        name: "Place Values",
        desc: "Understanding the value of each digit in a number",
      },
      {
        id: "c1-2",
        name: "Reading Large Numbers",
        desc: "How to read and write numbers up to millions",
      },
      {
        id: "c1-3",
        name: "Rounding Numbers",
        desc: "Round to the nearest 10, 100, or 1000",
      },
      {
        id: "c1-4",
        name: "Number Patterns",
        desc: "Find the rule and continue a number pattern",
      },
    ],
    notes: [
      "Place value tells us what each digit is worth — ones, tens, hundreds, thousands",
      "5,432,109 is read as 'five million four hundred and thirty-two thousand one hundred and nine'",
      "To round: look at the digit after the place — 5 or more, round up",
      "Patterns follow a rule — find it to predict the next numbers",
    ],
  },
  {
    id: 2,
    name: "Four Operations",
    sinhala: "මූලික ක්‍රියා",
    accent: "#8B5CF6",
    iconKey: "ops",
    desc: "Master addition, subtraction, multiplication and division with big numbers",
    concepts: [
      {
        id: "c2-1",
        name: "Addition",
        desc: "Adding large numbers with carrying",
      },
      { id: "c2-2", name: "Subtraction", desc: "Subtracting with borrowing" },
      {
        id: "c2-3",
        name: "Multiplication",
        desc: "Multi-digit multiplication methods",
      },
      { id: "c2-4", name: "Division", desc: "Long division step by step" },
    ],
    notes: [
      "Always line up digits by place value when adding or subtracting",
      "Multiply each digit then add the partial results together",
      "Long division: Divide, Multiply, Subtract, Bring down, Repeat",
      "Check your answer: quotient × divisor + remainder = original number",
    ],
  },
  {
    id: 3,
    name: "Fractions",
    sinhala: "භාග",
    accent: "#00D9C0",
    iconKey: "frac",
    desc: "Understand parts of a whole and work with different types of fractions",
    concepts: [
      {
        id: "c3-1",
        name: "Types of Fractions",
        desc: "Proper, improper and mixed fractions",
      },
      {
        id: "c3-2",
        name: "Equivalent Fractions",
        desc: "Fractions that look different but are equal",
      },
      {
        id: "c3-3",
        name: "Adding & Subtracting",
        desc: "Working with same and different denominators",
      },
      {
        id: "c3-4",
        name: "Multiplying Fractions",
        desc: "Multiply numerators and denominators",
      },
    ],
    notes: [
      "Proper: numerator < denominator (3/4). Improper: numerator > denominator (7/4)",
      "Mixed fraction: whole number + proper fraction, like 1 3/4",
      "To add fractions with different denominators, find the LCD first",
      "Multiply straight across: a/b × c/d = ac/bd",
    ],
  },
  {
    id: 4,
    name: "Decimals",
    sinhala: "දශම",
    accent: "#FF7A45",
    iconKey: "dec",
    desc: "Work with decimal numbers, convert them, and do calculations",
    concepts: [
      {
        id: "c4-1",
        name: "Decimal Place Value",
        desc: "Tenths, hundredths, and thousandths",
      },
      {
        id: "c4-2",
        name: "Fractions to Decimals",
        desc: "How to convert between the two",
      },
      {
        id: "c4-3",
        name: "Decimal Operations",
        desc: "Add, subtract, multiply decimals",
      },
      {
        id: "c4-4",
        name: "Rounding Decimals",
        desc: "Round to given decimal places",
      },
    ],
    notes: [
      "3.14 means 3 whole and 14 hundredths — the dot separates wholes from parts",
      "To convert fraction to decimal: divide numerator by denominator",
      "When adding or subtracting, always line up the decimal points",
      "To multiply: ignore the decimal, multiply, then put it back",
    ],
  },
  {
    id: 5,
    name: "Integers",
    sinhala: "පූර්ණ සංඛ්‍යා",
    accent: "#3B82F6",
    iconKey: "int",
    desc: "Explore positive and negative numbers on the number line",
    concepts: [
      {
        id: "c5-1",
        name: "Positive & Negative",
        desc: "Understanding integers on a number line",
      },
      {
        id: "c5-2",
        name: "Comparing Integers",
        desc: "Which is bigger? Using < and > signs",
      },
      {
        id: "c5-3",
        name: "Adding Integers",
        desc: "Rules for adding positive and negative numbers",
      },
      {
        id: "c5-4",
        name: "Subtracting Integers",
        desc: "Two negatives make a positive",
      },
    ],
    notes: [
      "Integers include ..., -3, -2, -1, 0, 1, 2, 3, ...",
      "Positive numbers are always greater than negative numbers",
      "Same signs: add and keep the sign. (+3)+(+5)=+8",
      "Different signs: subtract and take the sign of the bigger number",
    ],
  },
  {
    id: 6,
    name: "Algebra",
    sinhala: "වීජ ගණිතය",
    accent: "#EC4899",
    iconKey: "alg",
    desc: "Use letters and symbols to represent numbers and solve problems",
    concepts: [
      {
        id: "c6-1",
        name: "Variables",
        desc: "Letters like x, y, n that stand for unknown numbers",
      },
      {
        id: "c6-2",
        name: "Expressions",
        desc: "Writing math sentences with letters and numbers",
      },
      {
        id: "c6-3",
        name: "Simple Equations",
        desc: "Finding the unknown value using = sign",
      },
      {
        id: "c6-4",
        name: "Solving Equations",
        desc: "Step by step — do the same to both sides",
      },
    ],
    notes: [
      "A variable represents an unknown number — like a box waiting to be filled",
      "Expression: 3x + 5 means '3 times x, then add 5'",
      "Equation has an = sign: 2x + 3 = 11",
      "Solve by doing the same operation to both sides until x is alone",
    ],
  },
  {
    id: 7,
    name: "Geometry",
    sinhala: "ජ්‍යාමිතිය",
    accent: "#F59E0B",
    iconKey: "geo",
    desc: "Study shapes, angles, lines and their special properties",
    concepts: [
      {
        id: "c7-1",
        name: "Points, Lines & Angles",
        desc: "The building blocks of geometry",
      },
      {
        id: "c7-2",
        name: "Types of Angles",
        desc: "Acute, right, obtuse, straight and reflex",
      },
      {
        id: "c7-3",
        name: "Triangles",
        desc: "Types and properties of triangles",
      },
      {
        id: "c7-4",
        name: "Quadrilaterals",
        desc: "Squares, rectangles, parallelograms and more",
      },
    ],
    notes: [
      "A point has no size, a line goes on forever, a segment has two ends",
      "Right angle = 90°, Acute < 90°, Obtuse between 90° and 180°",
      "Angles in a triangle always add up to 180°",
      "Square: all sides equal, all angles 90°",
    ],
  },
  {
    id: 8,
    name: "Measurement",
    sinhala: "මිනුම්",
    accent: "#22C55E",
    iconKey: "meas",
    desc: "Measure length, area, volume and perimeter of shapes",
    concepts: [
      {
        id: "c8-1",
        name: "Length",
        desc: "Measuring and converting between units",
      },
      {
        id: "c8-2",
        name: "Perimeter",
        desc: "The distance around the outside of a shape",
      },
      { id: "c8-3", name: "Area", desc: "The space inside a flat shape" },
      { id: "c8-4", name: "Volume", desc: "The space inside a 3D object" },
    ],
    notes: [
      "1 km = 1000 m, 1 m = 100 cm, 1 cm = 10 mm",
      "Perimeter of rectangle = 2 × (length + width)",
      "Area of rectangle = length × width",
      "Volume of cuboid = length × width × height",
    ],
  },
  {
    id: 9,
    name: "Statistics",
    sinhala: "සංඛ්‍යානය",
    accent: "#06B6D4",
    iconKey: "stat",
    desc: "Collect, organise and understand data using graphs and averages",
    concepts: [
      {
        id: "c9-1",
        name: "Collecting Data",
        desc: "How to gather and organise information",
      },
      {
        id: "c9-2",
        name: "Bar Graphs",
        desc: "Drawing and reading bar charts",
      },
      {
        id: "c9-3",
        name: "Mean (Average)",
        desc: "Finding the average of a set of numbers",
      },
      {
        id: "c9-4",
        name: "Mode & Range",
        desc: "Most common value and the spread of data",
      },
    ],
    notes: [
      "Data is collected information — numbers, facts, or measurements",
      "Bar graph: taller bar means a bigger number",
      "Mean = sum of all values ÷ how many values there are",
      "Mode = most frequent value. Range = biggest − smallest",
    ],
  },
  {
    id: 10,
    name: "Patterns",
    sinhala: "රටා",
    accent: "#A855F7",
    iconKey: "pat",
    desc: "Find and describe number patterns and relationships between things",
    concepts: [
      {
        id: "c10-1",
        name: "Number Sequences",
        desc: "Finding the rule in a number pattern",
      },
      {
        id: "c10-2",
        name: "Shape Patterns",
        desc: "Patterns made with shapes that change",
      },
      {
        id: "c10-3",
        name: "Growing Patterns",
        desc: "Patterns that grow bigger step by step",
      },
      {
        id: "c10-4",
        name: "Relationships",
        desc: "How two things change together",
      },
    ],
    notes: [
      "Find the difference between numbers to discover the pattern rule",
      "If the difference is the same each time, it is a linear pattern",
      "Shape patterns change in colour, size, rotation, or number",
      "A relationship connects two things, like hours worked and money earned",
    ],
  },
];
