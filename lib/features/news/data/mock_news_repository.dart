import 'package:newsllm/core/theme/app_colors.dart';
import 'package:newsllm/features/news/domain/models/news_article.dart';
import 'package:newsllm/features/quiz/domain/models/quiz_models.dart';

class MockNewsRepository {
  MockNewsRepository._();

  static const List<NewsArticle> articles = [
    NewsArticle(
      id: 'bangladesh-green-growth-roadmap',
      newspaperName: 'The Daily Star',
      category: 'NATIONAL',
      title: 'Bangladesh introduces a national green growth roadmap',
      summary:
          'The roadmap prioritises renewable energy, sustainable jobs and '
          'climate-resilient infrastructure across the country.',
      content:
          'The national green growth roadmap presents a long-term plan for '
          'combining economic development with environmental protection. It '
          'focuses on renewable energy, employment, resilient infrastructure '
          'and cooperation between government agencies and stakeholders.',
      examTakeaway:
          'Remember the purpose of the roadmap, its major priority areas and '
          'its connection with sustainable national development.',
      readingTime: '4 min read',
      accentColor: AppColors.primary,
      facts: [
        NewsFact(
          label: 'WHO',
          value: 'Government agencies and relevant stakeholders',
        ),
        NewsFact(label: 'WHAT', value: 'A national green growth roadmap'),
        NewsFact(
          label: 'WHEN',
          value: 'Announced in today’s current-affairs coverage',
        ),
        NewsFact(label: 'WHERE', value: 'Bangladesh'),
        NewsFact(
          label: 'WHY',
          value: 'To support sustainable and climate-resilient development',
        ),
      ],
      keyTerms: [
        'Green growth',
        'Renewable energy',
        'Sustainable jobs',
        'Climate resilience',
      ],
      quizQuestions: [
        QuizQuestion(
          id: 'green-roadmap-purpose',
          question: 'What is the main purpose of the green growth roadmap?',
          options: [
            'To support sustainable national development',
            'To reduce international cooperation',
            'To stop renewable-energy projects',
            'To replace all existing public services',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The roadmap connects economic development with sustainability '
              'and climate resilience.',
        ),
        QuizQuestion(
          id: 'green-roadmap-priority',
          question: 'Which area is prioritised by the roadmap?',
          options: [
            'Renewable energy',
            'Celebrity entertainment',
            'International sports',
            'Luxury imports',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Renewable energy is one of the roadmap’s principal priorities.',
        ),
        QuizQuestion(
          id: 'green-roadmap-location',
          question: 'Where is the roadmap being introduced?',
          options: ['Bangladesh', 'Nepal', 'Japan', 'Brazil'],
          correctAnswerIndex: 0,
          explanation: 'The briefing concerns a national plan for Bangladesh.',
        ),
      ],
    ),
    NewsArticle(
      id: 'regional-economic-cooperation',
      newspaperName: 'Prothom Alo',
      category: 'INTERNATIONAL',
      title: 'Regional leaders discuss stronger economic cooperation',
      summary:
          'The meeting highlighted trade, technology and cross-border '
          'collaboration between neighbouring countries.',
      content:
          'Regional representatives discussed ways to strengthen trade, '
          'digital connectivity and cooperation between neighbouring '
          'countries. The talks also considered shared economic challenges '
          'and opportunities for long-term regional development.',
      examTakeaway:
          'Focus on the participating regions, the purpose of economic '
          'cooperation and the areas identified for collaboration.',
      readingTime: '3 min read',
      accentColor: AppColors.primary,
      facts: [
        NewsFact(
          label: 'WHO',
          value: 'Regional leaders and government representatives',
        ),
        NewsFact(
          label: 'WHAT',
          value: 'A meeting on stronger economic cooperation',
        ),
        NewsFact(
          label: 'WHEN',
          value: 'Reported in today’s international news',
        ),
        NewsFact(label: 'WHERE', value: 'The South Asian region'),
        NewsFact(
          label: 'WHY',
          value: 'To improve trade, technology and regional collaboration',
        ),
      ],
      keyTerms: [
        'Regional cooperation',
        'Cross-border trade',
        'Digital connectivity',
        'Economic development',
      ],
      quizQuestions: [
        QuizQuestion(
          id: 'regional-cooperation-focus',
          question: 'What was a major focus of the regional meeting?',
          options: [
            'Trade and technology cooperation',
            'Ending all regional trade',
            'A private sporting competition',
            'Reducing digital connectivity',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Trade, technology and cross-border cooperation were central '
              'subjects of the meeting.',
        ),
        QuizQuestion(
          id: 'regional-cooperation-benefit',
          question: 'What is an expected benefit of regional cooperation?',
          options: [
            'Stronger shared economic development',
            'Less communication between countries',
            'Removal of every public institution',
            'An end to technological development',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Regional cooperation can support shared economic development.',
        ),
      ],
    ),
    NewsArticle(
      id: 'digital-payment-expansion',
      newspaperName: 'The Business Standard',
      category: 'BUSINESS',
      title: 'Digital payment services continue to expand',
      summary:
          'New services aim to make everyday transactions faster, safer and '
          'more accessible.',
      content:
          'Banks and financial-technology providers are expanding digital '
          'payment options. The services are intended to improve transaction '
          'speed, security and financial access for individuals and small '
          'businesses.',
      examTakeaway:
          'Remember the meaning of digital payments and their role in '
          'financial inclusion, security and economic activity.',
      readingTime: '3 min read',
      accentColor: AppColors.primary,
      facts: [
        NewsFact(
          label: 'WHO',
          value: 'Banks and financial-technology providers',
        ),
        NewsFact(label: 'WHAT', value: 'Expansion of digital payment services'),
        NewsFact(
          label: 'WHEN',
          value: 'During the continuing digital transformation',
        ),
        NewsFact(label: 'WHERE', value: 'Across Bangladesh'),
        NewsFact(
          label: 'WHY',
          value: 'To improve speed, safety and financial accessibility',
        ),
      ],
      keyTerms: [
        'Digital payment',
        'Financial technology',
        'Financial inclusion',
        'Transaction security',
      ],
      quizQuestions: [
        QuizQuestion(
          id: 'digital-payment-objective',
          question: 'What is an objective of expanding digital payments?',
          options: [
            'Making transactions faster and more accessible',
            'Preventing people from using financial services',
            'Removing transaction security',
            'Closing all banking services',
          ],
          correctAnswerIndex: 0,
          explanation:
              'The services aim to improve transaction speed, safety and '
              'accessibility.',
        ),
        QuizQuestion(
          id: 'digital-payment-providers',
          question: 'Who is helping expand digital payment services?',
          options: [
            'Banks and financial-technology providers',
            'Only sports organisations',
            'Foreign tourists',
            'Entertainment companies only',
          ],
          correctAnswerIndex: 0,
          explanation:
              'Banks and financial-technology providers are leading the '
              'expansion.',
        ),
      ],
    ),
  ];

  static NewsArticle? findById(String id) {
    for (final article in articles) {
      if (article.id == id) {
        return article;
      }
    }

    return null;
  }

  static NewsArticle? findByTitle(String title) {
    for (final article in articles) {
      if (article.title == title) {
        return article;
      }
    }

    return null;
  }

  static List<NewsArticle> articlesByCategory(String category) {
    return articles.where((article) {
      return article.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  static List<NewsArticle> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return articles;
    }

    return articles.where((article) {
      return article.title.toLowerCase().contains(normalizedQuery) ||
          article.summary.toLowerCase().contains(normalizedQuery) ||
          article.category.toLowerCase().contains(normalizedQuery) ||
          article.newspaperName.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
