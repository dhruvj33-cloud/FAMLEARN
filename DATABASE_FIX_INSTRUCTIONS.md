# Database Fix Instructions

## Issue
Some quiz questions are missing the "block" (subtopic) field, causing incorrect analytics display.

## Fix Steps

1. **Open your FamLearn app** in the browser (http://localhost or wherever you're running it)

2. **Open Browser Console** (Press F12, then click "Console" tab)

3. **Copy and paste this entire script** into the console and press Enter:

```javascript
async function fixMissingBlocks() {
    const SUPABASE_URL = localStorage.getItem('SUPABASE_URL');
    const SUPABASE_KEY = localStorage.getItem('SUPABASE_KEY');
    const client = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

    console.log('🔍 Fetching all quiz results...');
    const { data: quizzes, error } = await client.from('quiz_results').select('*');
    if (error) { console.error('❌ Error:', error); return; }

    console.log(`📊 Found ${quizzes.length} quizzes`);
    let updatedCount = 0;

    for (const quiz of quizzes) {
        let needsUpdate = false;
        const updatedQuestions = quiz.questions.map(q => {
            if (!q.block) {
                needsUpdate = true;
                let defaultBlock = 'General';
                if (quiz.subject === 'Mathematics') defaultBlock = 'Algebra & Equations';
                else if (quiz.subject === 'Physics') defaultBlock = 'Mechanics & Motion';
                else if (quiz.subject === 'Chemistry') defaultBlock = 'Physical Chemistry';
                else if (quiz.subject === 'Biology') defaultBlock = 'Cell Biology & Genetics';
                else if (quiz.subject === 'History') defaultBlock = 'World Wars & Contemporary';
                return { ...q, block: defaultBlock };
            }
            return q;
        });

        if (needsUpdate) {
            console.log(`🔧 Updating quiz ${quiz.id.substring(0, 8)}... (${quiz.subject})`);
            const { error: updateError } = await client.from('quiz_results').update({ questions: updatedQuestions }).eq('id', quiz.id);
            if (updateError) console.error(`❌ Error:`, updateError);
            else { updatedCount++; console.log(`✅ Updated!`); }
        }
    }

    console.log(`\n🎉 Done! Updated ${updatedCount} quizzes`);
}

fixMissingBlocks();
```

4. **Wait for the script to complete** - You should see green checkmarks (✅) for each updated quiz

5. **Refresh the page** and go to Performance Analysis - the numbers should now be correct!

## What This Does

- Adds a "block" field to all questions that don't have one
- Assigns a default block based on the quiz subject
- For Mathematics quizzes: assigns "Algebra & Equations"
- For Physics quizzes: assigns "Mechanics & Motion"
- And so on...

## Expected Result

After running this:
- **Questions Attempted**: Should show 20 (not 2)
- **Accuracy**: Should show 40% ✓ (correct)
- **Correct Answers**: Should show 8 (not 0)
