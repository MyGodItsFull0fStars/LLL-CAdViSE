Dear Prof. Kasioulis et al.,

in the next paragraphs you will find the review of your paper "Power Estimation Models for Edge Computing Devices".

Overall I enjoyed reading the paper as it has a clear structure, the topic is becoming more and more important and the methodology and metrics used were logical choices.

Now to some points that could be improved.

In section 3 Methodology, it is mentioned that the workflow pre-processing step includes identifying possible missing values, but it is not mentioned how this will be resolved.

In 3.1 Implementation Aspects: It is not mentioned, which tool is used as the 'time series database' to store monitoring traces.

The metric MAPE is used in the Abstract to show how well the best model is performing, but that metric is missing in multiple sections regarding the various prediction models.

In Fig. 4 some gaps can be seen that are not explained in the text.

The comparison values in Fig. 5, 6 for predicted and actual values are hard to read and comprehend based on the provided graphs.
Line plots might be the better option.

While stated in the text, the linear regression fitting line could be added to the legends of the graphs.

It is not stated if and how often experiments such as local inference was repeated for each configuration to ensure a good sample size. Also, it was not mentioned how many datapoints were collected and used for calculating the metric results. As MSE is not scale invariant, the results of the MSE metric cannot be reproduced as the number of datapoints is missing.

The variables P_eth,dn, P_eth,up, P_wifi,up and P_wifi,dn were used but never defined.

In section 4.2 the linear regression results are shown for the training data, but not for the test data.

As already stated, overall I enjoyed reading this paper and the mentioned points are merely things to improve upon.

Kind Regards,

Christian Bauer
