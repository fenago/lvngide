# CodeSphere IDE Deployment Guide

## Quick Start - Deploy to Railway

### Prerequisites
- GitHub account
- Railway account (sign up at https://railway.app/)
- Your repository pushed to GitHub

### Step-by-Step Deployment

#### 1. Create Railway Account
1. Go to https://railway.app/
2. Click "Login with GitHub"
3. Authorize Railway to access your GitHub

#### 2. Create New Project
1. Click "+ New Project" in Railway dashboard
2. Select "Deploy from GitHub repo"
3. Select your repository: `fenago/lvngide`
4. Railway will automatically detect the Dockerfile

#### 3. Configure Environment (if needed)
Railway will auto-detect most settings, but you can customize:
- **PORT**: 3000 (default, Railway will assign dynamically)
- **NODE_ENV**: production (auto-set)

#### 4. Deploy!
1. Railway will automatically build and deploy
2. Build time: ~10-15 minutes (first time)
3. You'll get a URL like: `https://codesphere-production.up.railway.app`

#### 5. Custom Domain (Optional)
1. Go to Settings → Domains
2. Click "Generate Domain" for free railway.app domain
3. Or add your own custom domain

### Cost Estimate
- **Hobby Plan**: $5/month (500 hours)
- **Pro Plan**: $20/month (unlimited)
- First $5 is free credits

---

## Alternative: Deploy to Render

### Prerequisites
- GitHub account
- Render account (sign up at https://render.com/)

### Steps

#### 1. Create Render Account
1. Go to https://render.com/
2. Sign up with GitHub

#### 2. Create New Web Service
1. Click "New +" → "Web Service"
2. Connect your GitHub repository: `fenago/lvngide`
3. Configure:
   - **Name**: codesphere-ide
   - **Environment**: Docker
   - **Region**: Choose closest to your users
   - **Branch**: main
   - **Dockerfile Path**: Dockerfile (auto-detected)

#### 3. Set Instance Type
- **Free**: 512 MB RAM (will sleep after inactivity)
- **Starter**: $7/month - 512 MB RAM
- **Standard**: $25/month - 2 GB RAM (recommended)

#### 4. Deploy
1. Click "Create Web Service"
2. Build time: ~10-15 minutes
3. You'll get a URL like: `https://codesphere-ide.onrender.com`

---

## Local Docker Testing

### Build Docker Image Locally
```bash
# From the project root
docker build -t codesphere-ide .
```

### Run Locally
```bash
docker run -p 3000:3000 codesphere-ide
```

### Access
Open http://localhost:3000

### Stop Container
```bash
# Find container ID
docker ps

# Stop container
docker stop <container-id>
```

---

## Environment Variables

The following environment variables can be configured:

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 3000 | Port the server listens on |
| `NODE_ENV` | production | Node environment |
| `SHELL` | /bin/bash | Default shell for terminals |
| `THEIA_DEFAULT_PLUGINS` | local-dir:/app/plugins | Plugin directory |

---

## Troubleshooting

### Build Fails
**Problem**: Docker build times out or fails
**Solution**: 
- Check Railway/Render build logs
- Ensure all dependencies are in package.json
- Try building locally first

### Application Won't Start
**Problem**: Container starts but application crashes
**Solution**:
- Check application logs in Railway/Render dashboard
- Verify PORT environment variable is set correctly
- Ensure all required files are copied in Dockerfile

### Slow Performance
**Problem**: IDE is slow or unresponsive
**Solution**:
- Upgrade to higher tier (more RAM/CPU)
- Check if service is sleeping (free tiers)
- Consider using CDN for static assets

### WebSocket Connection Fails
**Problem**: Terminal or file watching doesn't work
**Solution**:
- Ensure WebSocket is enabled on your platform
- Check if firewall/proxy is blocking WebSocket
- Verify CORS settings if using custom domain

---

## Monitoring & Maintenance

### Health Checks
The Dockerfile includes a health check that pings http://localhost:3000/ every 30 seconds.

### Logs
- **Railway**: View logs in project dashboard → Deployments → Logs
- **Render**: View logs in service dashboard → Logs tab

### Updates
1. Push changes to GitHub main branch
2. Railway/Render will auto-deploy
3. Monitor deployment in dashboard

---

## Security Considerations

### What's Already Configured
- ✅ Non-root user (theia:1001)
- ✅ Minimal production image
- ✅ Health checks enabled
- ✅ No unnecessary files in image (.dockerignore)

### Recommendations
1. **Authentication**: Add authentication layer (OAuth, basic auth)
2. **HTTPS**: Use platform's SSL or custom domain with SSL
3. **Rate Limiting**: Add rate limiting for API endpoints
4. **Secrets**: Store sensitive data in environment variables, not code

---

## Cost Optimization

### Railway
- Use Hobby plan ($5/month) for low traffic
- Monitor usage in dashboard
- Scale down during off-hours if possible

### Render
- Free tier for testing (sleeps after 15 min inactivity)
- Starter ($7/month) for production
- Standard ($25/month) for better performance

### Tips
- Enable sleep mode for dev/staging environments
- Use caching for faster builds
- Monitor and optimize Docker image size

---

## Next Steps

1. **Deploy**: Follow Railway or Render steps above
2. **Test**: Access your deployed URL and test all features
3. **Custom Domain**: Add your own domain
4. **Monitor**: Set up monitoring and alerts
5. **Secure**: Add authentication if needed
6. **Scale**: Upgrade tier as traffic grows

---

## Support

- **Railway Docs**: https://docs.railway.app/
- **Render Docs**: https://render.com/docs
- **Docker Docs**: https://docs.docker.com/
- **Theia Docs**: https://theia-ide.org/docs/

---

## Quick Reference Commands

```bash
# Build Docker image
docker build -t codesphere-ide .

# Run locally
docker run -p 3000:3000 codesphere-ide

# Push to GitHub (triggers auto-deploy)
git add .
git commit -m "Deploy to production"
git push origin main

# View local logs
docker logs <container-id>

# Stop container
docker stop <container-id>

# Remove container
docker rm <container-id>

# Remove image
docker rmi codesphere-ide
```

---

Made with ❤️ by LVNG.ai (Dr. Ernesto Lee and Matty Squarzoni)
