# IBMCloud Helm Deploy

> Github Action for deploy HelmChart in IBMCloud kubernetes service

## Example

```yml

name: Deploy IBM Cloud

on:
  release:
    types: [created]

env:
  GITHUB_SHA: ${{ github.sha }}
  IBM_CLOUD_API_KEY: ${{ secrets.IBM_CLOUD_API_KEY }}
  ICR_NAMESPACE: ${{ secrets.ICR_NAMESPACE }}
  REGISTRY_HOSTNAME: ${{ secrets.REGISTRY_HOSTNAME }}
  IMAGE_NAME: my-image
  
jobs:
  setup-build-publish:
    name: Setup, Build, Publish, and Deploy
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Set output
        id: vars
        run: echo ::set-output name=tag::${GITHUB_REF#refs/*/}
      - name: Install npm dependencies

      - name: Build with Docker
        env:
          IMAGE_TAG: ${{ steps.vars.outputs.tag }}
        run: |
          docker build -t "$REGISTRY_HOSTNAME"/"$ICR_NAMESPACE"/"$IMAGE_NAME":"$IMAGE_TAG" \
            --build-arg GITHUB_REF="$GITHUB_REF" .

      - name: Push the image to ICR
        env:
          IMAGE_TAG: ${{ steps.vars.outputs.tag }}
        run: |
          docker push $REGISTRY_HOSTNAME/$ICR_NAMESPACE/$IMAGE_NAME:$IMAGE_TAG

      - uses: Oda2/ibmcloud-deploy@v1.6
        with:
          bucket-name: ${{ secrets.BUCKET_NAME_DEPLOY }}
          helm-name: ${{ secrets.PROJECT_BUCKET_NAME }}
          helm-app: ${{ secrets.PROJECT_HELM_NAME }}
          version-app: ${{ steps.vars.outputs.tag }}
          ibm-api-key: ${{ secrets.IBM_CLOUD_API_KEY }}
          ibm-region: ${{ secrets.IBM_REGION }}
          cluster-id: ${{ secrets.IBM_CLOUD_KS_ID_CLUSTER }}
```