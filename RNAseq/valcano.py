import plotly.express as px
import pandas as pd
import numpy as np
import dash
import dash_core_components as dcc
import dash_html_components as html

# Create a sample dataframe
df = pd.read_csv('results/results_airway.tsv', sep='\t')

# Define the function to create the plot
def my_plot_function(df, log2FoldChange_col, pvalue_col):
    # create a new column with modified p-values
    df['mod_pvalue'] = -np.log10(df[pvalue_col])

    # calculate the number of up-, down-, and non-significant genes
    up_count = len(df[(df[pvalue_col] < 0.05) & (df[log2FoldChange_col] > 0)])
    down_count = len(df[(df[pvalue_col] < 0.05) & (df[log2FoldChange_col] < 0)])
    non_sig_count = len(df[df[pvalue_col] >= 0.05])

    # create a scatter plot using plotly
    fig = px.scatter(df, x=log2FoldChange_col, y='mod_pvalue', color=np.where((df[pvalue_col] < 0.05) & (df[log2FoldChange_col] > 0), 'Upregulated',
                                                          np.where((df[pvalue_col] < 0.05) & (df[log2FoldChange_col] < 0), 'Downregulated', 'Non-significant')),
                     color_discrete_map={'Upregulated': 'red', 'Downregulated': 'blue', 'Non-significant': 'gray'})

    # add axis labels and title
    fig.update_layout(xaxis_title=log2FoldChange_col, yaxis_title='-log10(' + pvalue_col + ')',
                      title={'text': f"Volcano Plot of Differential Gene Expression ({up_count} up, {down_count} down, {non_sig_count} non-significant)",
                             'y': 0.95, 'x': 0.5, 'xanchor': 'center', 'yanchor': 'top'},
                       height=800,)

    return fig

# Create the Dash app
app = dash.Dash(__name__)

# Define the layout of the app
app.layout = html.Div([
    dcc.Graph(id='volcano-plot', figure=my_plot_function(df, 'log2FoldChange', 'pvalue'))
])

if __name__ == '__main__':
    app.run_server(debug=True)
