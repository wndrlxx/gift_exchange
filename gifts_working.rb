require 'csv'

filename = './input.csv'
csv = CSV.read(filename, headers: true)
# assume that CSV has > 2 emails
emails = []
csv.each { |row| emails << row['Email'] }
gift_list = {}
emails.each { |email| gift_list[email] = nil }

gift_list.keys.each do |sender|
  # skip if matched in a prior iteration
  next if gift_list[sender]

  # pick a random recipient
  recipient = emails.shuffle!.first
  while (recipient == sender)
    recipient = emails.shuffle!.first
  end

  if (emails.size > 3)
    # assign matching pair 
    # sender -> recipient and recipient -> sender 
    gift_list[sender] = recipient
    gift_list[recipient] = sender
    emails.delete(sender)
    emails.delete(recipient)
  else
    # base case
    # assign A->B, B->C, C->A to avoid infinite loop
    gift_list[sender] = recipient
    emails.delete(sender)
    emails.delete(recipient)
    gift_list[recipient] = emails.first
    gift_list[emails.first] = sender
  end
end

gift_list.each do |sender, recipient|
  puts "#{sender} -> #{recipient}"
end
