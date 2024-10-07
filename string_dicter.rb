# frozen_string_literal: true

# Дана строка s и словарь d, содержащий некие слова. Определите,можно ли
# строку s представить в последовательность разделенных пробелом слов,
# содержащихся в словаре d.
# Пример: дано, s =«двесотни», d = [«две», «сотни», «тысячи»]. Программа должна
# вернуть true, потому что «двесотни» могут быть представлены как «две сотни».
def string_dicter(s, d)
  # Преобразуем словарь в набор для быстрого поиска - О(1) вместо О(n)
  word_set = Set.new(d)
  n = s.length
  # Создаем массив dp
  dp = Array.new(n + 1, false)
  dp[0] = true # Пустая строка может быть разбита (базовое условие)

  (1..n).each do |i|
    (0...i).each do |j|
      if dp[j] && word_set.include?(s[j...i])
        dp[i] = true
        break
      end
    end
  end

  dp[n]
end

# Пример использования из условия (тест)
s = 'двесотни'
d = %w[две сотни тысячи]
puts string_dicter(s, d)
# frozen_string_literal: true

