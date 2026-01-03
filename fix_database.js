// Run this script in your browser console while on the FamLearn app
// It will add missing "block" fields to all questions

async function fixMissingBlocks() {
    // Use the global supabaseClient that's already initialized
    if (!window.supabaseClient) {
        console.error('❌ supabaseClient not found. Make sure you are logged in to the app.');
        return;
    }

    const client = window.supabaseClient;

    console.log('🔍 Fetching all quiz results...');
    const { data: quizzes, error } = await client
        .from('quiz_results')
        .select('*');

    if (error) {
        console.error('❌ Error fetching quizzes:', error);
        return;
    }

    console.log(`📊 Found ${quizzes.length} quizzes`);

    let updatedCount = 0;

    for (const quiz of quizzes) {
        let needsUpdate = false;
        const updatedQuestions = quiz.questions.map(q => {
            if (!q.block) {
                needsUpdate = true;
                // Assign default block based on subject
                let defaultBlock = 'General';

                if (quiz.subject === 'Mathematics') {
                    defaultBlock = 'Algebra & Equations';
                } else if (quiz.subject === 'Physics') {
                    defaultBlock = 'Mechanics & Motion';
                } else if (quiz.subject === 'Chemistry') {
                    defaultBlock = 'Physical Chemistry';
                } else if (quiz.subject === 'Biology') {
                    defaultBlock = 'Cell Biology & Genetics';
                } else if (quiz.subject === 'History') {
                    defaultBlock = 'World Wars & Contemporary';
                }

                return { ...q, block: defaultBlock };
            }
            return q;
        });

        if (needsUpdate) {
            console.log(`🔧 Updating quiz ${quiz.id} (${quiz.subject} - ${quiz.difficulty})`);
            const { error: updateError } = await client
                .from('quiz_results')
                .update({ questions: updatedQuestions })
                .eq('id', quiz.id);

            if (updateError) {
                console.error(`❌ Error updating quiz ${quiz.id}:`, updateError);
            } else {
                updatedCount++;
                console.log(`✅ Updated quiz ${quiz.id}`);
            }
        }
    }

    console.log(`\n🎉 Done! Updated ${updatedCount} quizzes`);
}

// Run the fix
fixMissingBlocks();
