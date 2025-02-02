# STAGE-1: CONFIGURING DOCKER IMAGE
FROM node:18-alpine AS builder

WORKDIR /app

# Define Build Arguments
ARG NEXT_PUBLIC_CLERK_SIGN_IN_URL
ARG NEXT_PUBLIC_CLERK_SIGN_UP_URL
ARG NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL
ARG NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL
ARG MONGODB_URL
ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
ARG CLERK_SECRET_KEY
ARG WEBHOOK_SECRET
ARG NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME
ARG NEXT_PUBLIC_CLOUDINARY_API_KEY
ARG NEXT_PUBLIC_CLOUDINARY_API_SECRET
ARG NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET
ARG NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME
ARG NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL
ARG NEXT_PUBLIC_STRIPE_SECRET_KEY
ARG NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET
ARG NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY

# Set Environment Variables For Build Stage
ENV NEXT_PUBLIC_CLERK_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_URL \
    NEXT_PUBLIC_CLERK_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_URL \
    NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL \
    NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL \
    MONGODB_URL=$MONGODB_URL \
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY \
    CLERK_SECRET_KEY=$CLERK_SECRET_KEY \
    WEBHOOK_SECRET=$WEBHOOK_SECRET \
    NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=$NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME \
    NEXT_PUBLIC_CLOUDINARY_API_KEY=$NEXT_PUBLIC_CLOUDINARY_API_KEY \
    NEXT_PUBLIC_CLOUDINARY_API_SECRET=$NEXT_PUBLIC_CLOUDINARY_API_SECRET \
    NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET=$NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET \
    NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME=$NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME \
    NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL=$NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL \
    NEXT_PUBLIC_STRIPE_SECRET_KEY=$NEXT_PUBLIC_STRIPE_SECRET_KEY \
    NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET=$NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET \
    NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY

# COPYING package.json & package-lock.json (IF EXISTS) FOR DPENDANCY INSTALLATION
COPY package.json ./
COPY package-lock.json ./

# CACHE CLEANING & INSTALLING DEPENDENCIES
RUN npm cache clean --force && \
    npm install --legacy-peer-deps

# COPING REST ESSENTIALS OF THIS APP
COPY . .

# PRODUCTION BUILD FOR THIS APP 
RUN npm run build:prod

# STAGE-2: FINAL DOCKER IMAGE BUILDS FOR THIS APP
FROM node:18-alpine AS runner

WORKDIR /app

# Define Build Arguments Again For The Final Stage
ARG NODE_ENV
ARG NEXT_PUBLIC_CLERK_SIGN_IN_URL
ARG NEXT_PUBLIC_CLERK_SIGN_UP_URL
ARG NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL
ARG NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL
ARG MONGODB_URL
ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
ARG CLERK_SECRET_KEY
ARG WEBHOOK_SECRET
ARG NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME
ARG NEXT_PUBLIC_CLOUDINARY_API_KEY
ARG NEXT_PUBLIC_CLOUDINARY_API_SECRET
ARG NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET
ARG NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME
ARG NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL
ARG NEXT_PUBLIC_STRIPE_SECRET_KEY
ARG NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET
ARG NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY

# COPY ESSENTIALS FROM BUILDER'S STAGE
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# PORT EXPOSING FOR APP ACCESS
EXPOSE 3000

# Set Environment Variables From Build Arguments
ENV PORT=3000 \
    NEXT_PUBLIC_CLERK_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_URL \
    NEXT_PUBLIC_CLERK_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_URL \
    NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL \
    NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL \
    MONGODB_URL=$MONGODB_URL \
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY \
    CLERK_SECRET_KEY=$CLERK_SECRET_KEY \
    WEBHOOK_SECRET=$WEBHOOK_SECRET \
    NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=$NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME \
    NEXT_PUBLIC_CLOUDINARY_API_KEY=$NEXT_PUBLIC_CLOUDINARY_API_KEY \
    NEXT_PUBLIC_CLOUDINARY_API_SECRET=$NEXT_PUBLIC_CLOUDINARY_API_SECRET \
    NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET=$NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET \
    NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME=$NEXT_PUBLIC_CLOUDINARY_BUCKET_NAME \
    NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL=$NEXT_PUBLIC_STRIPE_WEBHOOK_CHECKOUT_URL \
    NEXT_PUBLIC_STRIPE_SECRET_KEY=$NEXT_PUBLIC_STRIPE_SECRET_KEY \
    NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET=$NEXT_PUBLIC_STRIPE_WEBHOOK_SECRET \
    NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY

# RUN THIS APP IN PRODUCTION MODE
CMD ["npm", "run", "start:prod"]
