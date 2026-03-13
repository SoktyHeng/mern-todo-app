# Use lightweight Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# ── Install frontend dependencies & build ──
COPY TODO/todo_frontend/package*.json ./todo_frontend/
RUN cd todo_frontend && npm install

COPY TODO/todo_frontend/ ./todo_frontend/
RUN cd todo_frontend && npm run build

# ── Move build artifact to backend/static ──
RUN mkdir -p todo_backend/static && mv todo_frontend/build todo_backend/static/build

# ── Install backend dependencies ──
COPY TODO/todo_backend/package*.json ./todo_backend/
RUN cd todo_backend && npm install

COPY TODO/todo_backend/ ./todo_backend/

# Expose the app port
EXPOSE 5000

# Set working directory to backend and start
WORKDIR /app/todo_backend
CMD ["npm", "start"]