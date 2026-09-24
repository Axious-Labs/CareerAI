import { prisma } from '../config/database';
import bcrypt from 'bcryptjs';

async function seed() {
  console.log('🌱 Starting CareerAI database seed...');

  // 1. Seed Skills
  const initialSkills = [
    { name: 'Python', category: 'Programming Languages' },
    { name: 'Flutter', category: 'Mobile Development' },
    { name: 'Dart', category: 'Programming Languages' },
    { name: 'TypeScript', category: 'Programming Languages' },
    { name: 'Node.js', category: 'Backend Development' },
    { name: 'FastAPI', category: 'Backend Development' },
    { name: 'GenAI', category: 'Artificial Intelligence' },
    { name: 'LangGraph', category: 'Agentic AI' },
    { name: 'PyTorch', category: 'Machine Learning' },
    { name: 'PostgreSQL', category: 'Databases' },
    { name: 'Docker', category: 'DevOps & Cloud' },
  ];

  for (const skill of initialSkills) {
    await prisma.skill.upsert({
      where: { name: skill.name },
      update: {},
      create: skill,
    });
  }
  console.log(`✅ Seeded ${initialSkills.length} skills`);

  // 2. Seed Demo User
  const demoEmail = 'student@axiouslabs.org';
  const passwordHash = await bcrypt.hash('CareerAI2026!', 10);

  const demoUser = await prisma.user.upsert({
    where: { email: demoEmail },
    update: {},
    create: {
      name: 'Alex Chen',
      email: demoEmail,
      passwordHash,
      targetRole: 'AI/ML Engineer',
    },
  });
  console.log(`✅ Seeded demo user: ${demoUser.email}`);

  // 3. Seed Jobs
  const initialJobs = [
    {
      title: 'Junior AI Engineer',
      company: 'Axious Labs',
      location: 'Remote',
      description:
        'Help build next-generation career intelligence models and RAG workflows. Strong Python and foundational GenAI skills required.',
      sourceUrl: 'https://careers.axiouslabs.org/jobs/1',
    },
    {
      title: 'Associate Machine Learning Engineer',
      company: 'TechFlow Systems',
      location: 'San Francisco, CA (Hybrid)',
      description:
        'Develop data pipelines, fine-tune open weights LLMs, and optimize inference latency.',
      sourceUrl: 'https://careers.techflow.io/jobs/ml-assoc',
    },
    {
      title: 'Junior Full-Stack & AI Developer',
      company: 'Nexus Innovations',
      location: 'Remote',
      description:
        'Build modern Flutter frontends and TypeScript backends powered by generative AI.',
      sourceUrl: 'https://nexusinnovations.tech/jobs/fullstack-ai',
    },
  ];

  for (const job of initialJobs) {
    const existingJob = await prisma.job.findFirst({
      where: { title: job.title, company: job.company },
    });
    if (!existingJob) {
      await prisma.job.create({ data: job });
    }
  }
  console.log(`✅ Seeded ${initialJobs.length} starter jobs`);

  console.log('🎉 Seed completed successfully!');
}

seed()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
