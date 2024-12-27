---
title: "The Algorithm of the Dressings 🥬+🥕+❓️=🥗"
date: 2024-12-28T00:03:01+04:00
draft: false
---
Martun said he read many books about healthy food and didn't become healthy. I agree, that reading and doing is very different. But I think that nudges are really important. 

I'm pretty sure Martun doesn't read my blogs, but I don't write for people to read, so read at your own risk.

Let's talk about the simplest salad we can make cabbage🥬+carrot🥕 = 🥗.

# Do you want to eat it?

I don't :) , it's plain. Something is missing, apparently it's called **dressing**.

# What is dressing?
It's a sauce that you put on the salad to make it tasty.

## I'm a software engineer and I need algorithms for dressings so here is one


{{< rawhtml >}}

  <pre class="mermaid">
  graph TD
    SD[Salad Dressing] --> F[Fat Base<br>3 parts]
    SD --> A[Acid<br>1 part]
    SD --> FE[Flavor Enhancers<br>to taste]
    SD --> E[Emulsifier<br>optional]
    SD --> S[Seasonings]

    F --> |Oils| F1[Olive Oil<br>Avocado Oil<br>Walnut Oil<br>Sesame Oil<br>Grapeseed Oil]
    F --> |Creamy| F2[Yogurt<br>Mayonnaise<br>Tahini<br>Sour Cream<br>Buttermilk]

    A --> |Vinegars| A1[Balsamic<br>Red Wine<br>Apple Cider<br>Rice<br>Sherry<br>Champagne]
    A --> |Citrus| A2[Lemon<br>Lime<br>Orange<br>Grapefruit]

    FE --> |Aromatics| FE1[Garlic<br>Shallots<br>Ginger<br>Scallions]
    FE --> |Herbs| FE2[Basil<br>Dill<br>Parsley<br>Cilantro<br>Tarragon]
    FE --> |Sweet| FE3[Honey<br>Maple Syrup<br>Agave]
    FE --> |Umami| FE4[Miso<br>Soy Sauce<br>Fish Sauce<br>Worcestershire]

    E --> E1[Mustard<br>Honey<br>Egg Yolk<br>Miso]

    S --> S1[Salt<br>Pepper<br>Red Pepper Flakes<br>Sumac<br>Za'atar]

    style SD fill:#f9f,stroke:#333,stroke-width:4px
    style F fill:#ffcc99,stroke:#333
    style A fill:#99ff99,stroke:#333
    style FE fill:#99ccff,stroke:#333
    style E fill:#ffff99,stroke:#333
    style S fill:#ff9999,stroke:#333
  </pre>
  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  </script>
{{< /rawhtml >}}

I've created 2 dressings for this simple salad, it's very easy and tasty, but each dressing tastes different. Oil/fats + acids + spices +  and(optional) mustard/honey.

Try different combinations with any vegetables, and comment on your favorite.