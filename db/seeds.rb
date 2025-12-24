# Clear existing data
Message.destroy_all
Chat.destroy_all
Job.destroy_all
User.destroy_all

# Create Users
worker = User.create!(
  name: "João Trabalhador",
  email: "worker@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: "worker"
)

client = User.create!(
  name: "Maria Cliente",
  email: "client@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: "client"
)

# Create Jobs
Job.create!(
  title: "Consertar vazamento na pia",
  description: "A pia da cozinha está pingando muito, preciso de um encanador urgente.",
  price: 150.00,
  status: :open,
  client: client
)

Job.create!(
  title: "Pintar quarto de bebê",
  description: "Preciso pintar um quarto de 3x3m, cor azul claro.",
  price: 300.00,
  status: :open,
  client: client
)

job_in_progress = Job.create!(
  title: "Instalar ventilador de teto",
  description: "Tenho o ventilador, preciso apenas da instalação.",
  price: 100.00,
  status: :in_progress,
  client: client,
  worker: worker
)

# Create Chat
chat = Chat.create!(job: job_in_progress)
Message.create!(chat: chat, user: client, content: "Olá, que horas você pode vir?")
Message.create!(chat: chat, user: worker, content: "Posso ir amanhã às 14h.")

puts "Seeds created successfully!"
