require 'csv'

filename = './input.csv'
csv = CSV.read filename, headers: true
emails = csv.map { |row| row['Email'] }
raise 'Error: CSV must contain 2+ emails!' if emails.size < 2

gift_list = Hash[emails.map { |email| [email, nil] }]

gift_list.each_key do |sender|
  # skip if matched in a prior iteration
  next if gift_list[sender]

  recipient = emails.shuffle!.first
  recipient = emails.shuffle!.first while recipient == sender

  gift_list[sender] = recipient
  emails.delete sender
  emails.delete recipient

  if emails.size != 3
    # assign sender -> recipient and recipient -> sender
    gift_list[recipient] = sender
  else
    # assign A->B, B->C, C->A to avoid infinite loop
    gift_list[recipient] = emails.first
    gift_list[emails.first] = sender
  end
end

gift_list.each { |from, to| puts "#{from} -> #{to}" }
