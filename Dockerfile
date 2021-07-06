FROM oda2/ibmcloud-cli

RUN ibmcloud --version && \
    ibmcloud config --check-version=false && \
    ibmcloud plugin install -f kubernetes-service && \
    ibmcloud plugin install -f container-registry && \
    ibmcloud plugin install -f schematics && \
    ibmcloud plugin install -f cloud-object-storage

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]