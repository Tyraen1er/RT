/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/09 14:58:42 by bmoiroud          #+#    #+#             */
/*   Updated: 2016/11/22 20:51:34 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

char			*ft_itoa(int n)
{
	char			*str;
	int				i;
	unsigned int	nb;

	nb = 0;
	i = 0;
	if ((str = (char *)malloc(sizeof(char) * (ft_nblen(n) + 1))) == NULL)
		return (NULL);
	if (n < 0)
		nb = (unsigned int)-n;
	else
		nb = (unsigned int)n;
	while (nb > 0 || i == 0)
	{
		str[i++] = nb % 10 + 48;
		nb /= 10;
	}
	if (n < 0)
		str[i++] = '-';
	str[i] = '\0';
	ft_strrev(str);
	return (str);
}
